class UserInterestsController < ApplicationController
  # GET /user_interests
  # GET /user_interests.json
  def index
    @user_interests = UserInterest.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @user_interests }
    end
  end

  # GET /user_interests/1
  # GET /user_interests/1.json
  def show
    @user_interest = UserInterest.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user_interest }
    end
  end

  # GET /user_interests/new
  # GET /user_interests/new.json
  def new
    @user_interest = UserInterest.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user_interest }
    end
  end

  # GET /user_interests/1/edit
  def edit
    @user_interest = UserInterest.find(params[:id])
  end

  # POST /user_interests
  # POST /user_interests.json
  def create
    @user_interest = UserInterest.new(params[:user_interest])

    respond_to do |format|
      if @user_interest.save
        format.html { redirect_to @user_interest, notice: 'User interest was successfully created.' }
        format.json { render json: @user_interest, status: :created, location: @user_interest }
      else
        format.html { render action: "new" }
        format.json { render json: @user_interest.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /user_interests/1
  # PUT /user_interests/1.json
  def update
    @user_interest = UserInterest.find(params[:id])

    respond_to do |format|
      if @user_interest.update_attributes(params[:user_interest])
        format.html { redirect_to @user_interest, notice: 'User interest was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user_interest.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_interests/1
  # DELETE /user_interests/1.json
  def destroy
    @user_interest = UserInterest.find(params[:id])
    @user_interest.destroy

    respond_to do |format|
      format.html { redirect_to user_interests_url }
      format.json { head :no_content }
    end
  end
end
