class MyPagesController < ApplicationController
  def you_suck_mo
    fbid = params[:fbid]
    interest_name = params[:interest_name]
    interest = Interest.find_by_name(interest_name)
    if interest == nil
      interest = Interest.new
      interest.name = interest_name
      interest.save
    end
    ui = UserInterest.find_by_fbid_and_interestid(fbid, interest.id)
    if ui == nil
      ui = UserInterest.new
      ui.fbid = fbid
      ui.interestid = interest.id
      ui.save
    end
    redirect_to '/home'
  end

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
    @events_to_show.delete_if { |event|
      if !event[1]
        false
      else
        event[1]['end_time'] < Time.now.iso8601 
      end
    }
    # filter events that are closed and whose hosts are not friends with the current user
    @events_to_show.delete_if do |event|
      if !event[1]
        false
      else 
        host_fbid = event[1]['owner']['id']
        if host_fbid == session[:fbid]
          false
        else
          event[1]['privacy_type'] == 'CLOSED' && session['graph'].get_connections('me', "friends/#{host_fbid}").empty?
        end
      end
    end

    # sort the events by start time
    @events_to_show.sort! { |e1, e2| 
      if !e1[1] and !e2[1] 
        0
      elsif !e1[1]
        1
      elsif !e2[1]
        -1
      else
        e1[1]['start_time'] <=> e2[1]['start_time']
      end
    }

    # suggested_events is now a list of hashes, each hash representing the fb
    # event to display to the user
  end

  def new_user_tag
    interest = Interest.find_by_name(params[:interest_tags])
    if interest == nil
      interest = Interest.new
      interest.name = params[:interest_tags]
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

    # filter events that are closed and whose hosts are not friends with the current user
    @events_to_show.delete_if do |event|
      host_fbid = event[1]['owner']['id']
      if host_fbid == session[:fbid]
        false
      else
        event[1]['privacy_type'] == 'CLOSED' && session['graph'].get_connections('me', "friends/#{host_fbid}").empty?
      end
    end

    # sort the events by start time
    @events_to_show.sort! { |e1, e2| e1[1]['start_time'] <=> e2[1]['start_time'] }
    @suggested_event_ids = @events_to_show.map { |x| x[0] }
  end

  def explore
    @suggested_interests = ['testing', 'pizza', 'partying']

    @query = params[:interest_name]

    interest_for_query = Interest.find_by_name(@query)
    if interest_for_query == nil
      interests_for_query = []
      @suggested_interests.each { |si| interests_for_query << Interest.find_by_name(si) }
    else interests_for_query = [interest_for_query]
    end
    

    interest_ids_for_query = interests_for_query.map { |x| x.id }
    @event_ids = Event.all.map { |event| event.fbeventid }
    @event_ids.delete_if do |event_id|
      ei2 = interest_ids_for_query.any? { |interest_id_for_query| 
        ei = EventInterest.find_by_fbeventid_and_interestid(event_id, interest_id_for_query.to_i)
        ei != nil
      }
      !ei2
    end
    @fb_event_hashes = @event_ids.map { |event_id| session[:graph].get_object(event_id) }
    @suggested_event_interests = @event_ids.map do |event_id|
      res = []
      EventInterest.find_all_by_fbeventid(event_id).each { |ei| res << Interest.find(ei.interestid).name }
      res
    end
    @events_to_show = [] # [ <event id> , <fb event object as hash> , <list of interest tags> ]
    0.upto(@event_ids.length-1) { |i| @events_to_show << [@event_ids[i], @fb_event_hashes[i], @suggested_event_interests[i]] }

  end

  def help
  end
end
