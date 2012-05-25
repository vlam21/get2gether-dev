class MyPagesController < ApplicationController
  def home
    api_key = '291005200984758'
    app_secret = 'bb8b3415dc375daf2da85894837e67f7'
    callback_url = 'http://127.0.0.1:3000/my_pages/home'
    @oauth = Koala::Facebook::OAuth.new(api_key, app_secret, callback_url)

    @user = "fail"

    if params['code'] == nil
      url = @oauth.url_for_oauth_code(:permissions => "publish_stream")
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
  end

  def new_user_tag
    @interest = Interest.new
    #print params[:input], "<----*******************"
    @interest.name = params[:interest]
    @interest.save
    @user_interest = UserInterest.new
    @user_interest.fbid = params[:fbid]
    @user_interest.interestid = @interest.id
    @user_interest.save
    redirect_to '/home'
  end
 
  def del_user_tag
    interestid =  params[:interest] 
    user_interest = UserInterest.find_by_fbid_and_interestid(params[:fbid], interestid) 
    user_interest.destroy
    redirect_to '/home'
  end



  def maps

  end

  def help
  end
end
