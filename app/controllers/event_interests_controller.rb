class EventInterestsController < ApplicationController
  # GET /event_interests
  # GET /event_interests.json
  def index
    @event_interests = EventInterest.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @event_interests }
    end
  end

  # GET /event_interests/1
  # GET /event_interests/1.json
  def show
    @event_interest = EventInterest.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event_interest }
    end
  end

  # GET /event_interests/new
  # GET /event_interests/new.json
  def new
    @event_interest = EventInterest.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event_interest }
    end
  end

  # GET /event_interests/1/edit
  def edit
    @event_interest = EventInterest.find(params[:id])
  end

  # POST /event_interests
  # POST /event_interests.json
  def create
    @event_interest = EventInterest.new(params[:event_interest])

    respond_to do |format|
      if @event_interest.save
        format.html { redirect_to @event_interest, notice: 'Event interest was successfully created.' }
        format.json { render json: @event_interest, status: :created, location: @event_interest }
      else
        format.html { render action: "new" }
        format.json { render json: @event_interest.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /event_interests/1
  # PUT /event_interests/1.json
  def update
    @event_interest = EventInterest.find(params[:id])

    respond_to do |format|
      if @event_interest.update_attributes(params[:event_interest])
        format.html { redirect_to @event_interest, notice: 'Event interest was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @event_interest.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /event_interests/1
  # DELETE /event_interests/1.json
  def destroy
    @event_interest = EventInterest.find(params[:id])
    @event_interest.destroy

    respond_to do |format|
      format.html { redirect_to event_interests_url }
      format.json { head :no_content }
    end
  end
end
