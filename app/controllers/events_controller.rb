class EventsController < ApplicationController
  before_filter :ensure_authenticated
  before_filter :ensure_event_manager, :excluding => [:index, :show]

  def index
    @events = Event.all
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new
  end

  def edit
    @event = Event.find(params[:id])
  end

  def create
    @event = Event.new(params[:event])
    @event.save
    if @event.valid?
      redirect_to @event, notice: 'Event was successfully created.'
    else
      render :new
    end
  end

  def update
    @event = Event.find params[:id]
    if @event.update_attributes(params[:event])
      redirect_to @event, notice: 'Event was successfully updated.' 
    else
      render :edit
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to events_url
  end
  
  protected 
  
  def ensure_event_manager
  end
  
end
