class MyPagesController < ApplicationController
  def home
    api_key = '291005200984758'
    app_secret = 'bb8b3415dc375daf2da85894837e67f7'
    callback_url = 'http://127.0.0.1:3000/my_pages/home'
    @oauth = Koala::Facebook::OAuth.new(api_key, app_secret, callback_url)

    if params['code'] == nil
      url = @oauth.url_for_oauth_code(:permissions => "create_event,rsvp_event")
      redirect_to(url)
    else
      code = params['code']
      access_token = @oauth.get_access_token(code)
      @graph = Koala::Facebook::API.new(access_token)
      @user = @graph.get_object("me")
      
      #putting id in session
      session[:fbid] = @user['id']
      session[:graph] = @graph
      
      userid = @user['id']
      name = @user['name']
      
      #if user is new, insert in db
      if User.find_by_fbid(userid) == nil
        @newUser = User.new(fbid:userid, name:name)
        @newUser.save
      end
    end

    # Find events to suggest to the user.
    user_interests = UserInterest.find_all_by_fbid(session[:fbid])
    interest_ids = user_interests.map { |ui| ui.interestid }
    suggested_event_ids = []
    interest_ids.each do |interest_id|
      event_interests = EventInterest.find_all_by_interestid(interest_id)
      event_interests.each { |ei| suggested_event_ids << ei.fbeventid }
    end
    suggested_event_ids.uniq! # removes duplicates
    suggested_events = suggested_event_ids.map { |event_id| session[:graph].get_object(event_id) }
    # Get interest tags for each event
    suggested_event_interests = suggested_event_ids.map do |event_id|
      res = []
      EventInterest.find_all_by_fbeventid(event_id).each { |ei| res << Interest.find(ei.interestid).name }
      res
    end
    @events_to_show = [] # [ <event id> , <fb event object as hash> , <list of interest tags> ]
    0.upto(suggested_event_ids.length-1) { |i| @events_to_show << [suggested_event_ids[i], suggested_events[i], suggested_event_interests[i]] }

    # filter events that have already ended
    @events_to_show.delete_if { |event| event[1]['end_time'] < Time.now.iso8601 }

    # sort the events by start time
    @events_to_show.sort! { |e1, e2| e1[1]['start_time'] <=> e2[1]['start_time'] }

    # suggested_events is now a list of hashes, each hash representing the fb
    # event to display to the user
  end

  def new_user_tag
    interest = Interest.find_by_name(params[:interest])
    if interest == nil
      interest = Interest.new
      interest.name = params[:interest]
      interest.save
    end
    user_interest = UserInterest.find_by_fbid_and_interestid(params[:fbid], interest.id)
    if user_interest == nil
      user_interest = UserInterest.new
      user_interest.fbid = params[:fbid]
      user_interest.interestid = interest.id
      user_interest.save
    end
    redirect_to '/home'
  end
 
  def del_user_tag
    interest_id =  params[:interest] 
    user_interest = UserInterest.find_by_fbid_and_interestid(params[:fbid], interest_id) 
    user_interest.destroy if user_interest != nil
    redirect_to '/home'
  end

  def maps
    @events = Event.all
  end

  def help
  end
end
