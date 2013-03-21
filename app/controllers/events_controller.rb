class EventsController < ApplicationController
  before_action :authenticate!, except: [:index, :show]

  def index
    @current_events = Event.current_events(4)
    @past_events = Event.past_events(3)
  end

  def show
    @event = Event.find_by_id params[:id]

    redirect_to events_path, alert: t('.event_not_found') unless @event
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(create_params).tap do |event|
      event.date = "#{params[:event][:date]} #{params[:event][:time]}"
      event.identity = current_identity
    end

    return redirect_to events_path, notice: t('.event_created') if @event.save

    flash.now[:alert] = t('.invalid_event')
    @event.date = params[:event][:date]
    render :new
  end

  def edit
    @event = Event.my_event params[:id], current_identity

    redirect_to events_path, alert: t('.event_not_found') unless @event

    @event.time = @event.date.strftime('%H:%M')
    @event.date = @event.date.strftime('%C-%m-%d')
  end

  def update
    @event = Event.my_event params[:id], current_identity
    @event.date = "#{params[:event][:date]} #{params[:event][:time]}"

    messages = if @event and @event.update_attributes create_params
                 { notice: t('.event_updated') }
               elsif !@event
                 { alert: t('.event_not_found') }
               end

    return redirect_to events_path, messages if messages 

    flash.now[:alert] = t('.invalid_event')
    @event.date = params[:event][:date]
    render :edit
  end

  def destroy
    @event = Event.my_event params[:id], current_identity

    messages = if @event and @event.destroy
                 { notice: t('.event_deleted') }
               elsif !@event
                 { alert: t('.event_not_found') }
               end

    redirect_to events_path, messages
  end

  private
  def create_params
    params.require(:event).permit(:name, :location, :description, :contact, :organizer, :date, :time)
  end
end
