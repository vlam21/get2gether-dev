class UserEventsController < ApplicationController
  # GET /user_events
  # GET /user_events.json
  def index
    @user_events = UserEvent.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @user_events }
    end
  end

  # GET /user_events/1
  # GET /user_events/1.json
  def show
    @user_event = UserEvent.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user_event }
    end
  end

  # GET /user_events/new
  # GET /user_events/new.json
  def new
    @user_event = UserEvent.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user_event }
    end
  end

  # GET /user_events/1/edit
  def edit
    @user_event = UserEvent.find(params[:id])
  end

  # POST /user_events
  # POST /user_events.json
  def create
    @user_event = UserEvent.new(params[:user_event])

    respond_to do |format|
      if @user_event.save
        format.html { redirect_to @user_event, notice: 'User event was successfully created.' }
        format.json { render json: @user_event, status: :created, location: @user_event }
      else
        format.html { render action: "new" }
        format.json { render json: @user_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /user_events/1
  # PUT /user_events/1.json
  def update
    @user_event = UserEvent.find(params[:id])

    respond_to do |format|
      if @user_event.update_attributes(params[:user_event])
        format.html { redirect_to @user_event, notice: 'User event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_events/1
  # DELETE /user_events/1.json
  def destroy
    @user_event = UserEvent.find(params[:id])
    @user_event.destroy

    respond_to do |format|
      format.html { redirect_to user_events_url }
      format.json { head :no_content }
    end
  end
end
