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

  def maps
    @events = Event.all
  end

  def help
  end
end
