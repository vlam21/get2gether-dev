class EventsController < ApplicationController
  # GET /events
  # GET /events.json
  def index
    @events = Event.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/new
  # GET /events/new.json
  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.json
  def create
    # Tutorial for creating fb events through Koala:
    # http://horserumble.com/creating-facebook-events-with-koala

    @event = Event.new

    # event_params = {
    #   :name => params[:eventname]
    #   :description => params[:description]
    # }
    # fbevent_info = session[:graph].put_object('me', 'events', event_params)
    #@event.fbeventid = fbevent_info[:id]

    # tags = [params[:tag1], params[:tag2], params[:tag3]]
    # tags.each do |tag|
    #   next if tag.strip.empty
    #   tag.downcase!
    #   interest = @Interest.find_by_name(tag)
    #   if interest == nil
    #     interest = Interest.new({ :name => tag })
    #     interest.save
    #   end
    #   EventInterest.new({ :fbeventid => @event.fbeventid, :interestid => interest.id }).save
    # end

    return

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render json: @event, status: :created, location: @event }
      else
        format.html { render action: "new" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end
end
