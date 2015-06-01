class EventsController < ApplicationController
  before_action :authenticate_user! , only: [:new, :create, :edit, :update, :destroy]
  before_action :redirect_back_if_no_admin_or_no_owner, only: [:show, :edit, :update, :destroy]


  # GET /events
  # GET /events.json
  def index
    if current_user != nil && current_user.id == 1
      @events = Event.all
    else
      @events = Event.by_user([1, current_user]).all
    end
    
    respond_to do |format|
      format.html
      format.json
    end    
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = load_event

    respond_to do |format|
      format.html
      format.json
    end   
  end

  # GET /events/new
  def new
    @event = Event.new
    @event.start_date = Time.zone.now
    @event.end_date = Time.zone.now + 15.minutes
    @event.color = current_user.id == 1 ? 'red' : '#5bc0de'
    @event.user = current_user

    respond_to do |format|
      format.html
    end
  end


  # GET /events/1/edit
  def edit
    @event ||= load_event

    respond_to do |format|
      format.html
    end
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)
    @event.user = current_user
    @event.color = '#5bc0de' if current_user.id != 1 #@brand-info

    respond_to do |format|
      if @event.save
        format.html { redirect_to events_url, notice: 'Event was successfully created.' }
        format.json { render action: 'show', status: :created, location: @event }
      else
        format.html { render action: 'new' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    @event ||= load_event

    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to events_url, notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event ||= load_event    

    if @event.destroy
      redirect_to events_url, success: t('activerecord.messages.successfull.destroyed', data: @event.title)
    else 
      flash[:alert] = t('activerecord.messages.error.destroyed', data: @event.title)
      render :show
    end      
  end

  # GET /events/1/pdf_invoice
  def pdf_invoice
    @event ||= load_event    

    respond_to do |format|
      format.pdf do
        pdf = InvoicePdf.new(@event, view_context)
        send_data pdf.render,
        filename: "invoice_#{@event.start_date.strftime("%Y-%m-%d")}.pdf",
        type: "application/pdf",
        disposition: "inline"        
      end
    end 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def load_event
      Event.find(params[:id])
    end

    def redirect_back_if_no_admin_or_no_owner
      if user_signed_in?
        @event ||= load_event
        if current_user.id != 1 && @event.user != current_user
          redirect_to events_url, alert: "Brak uprawnień!"
        end
      else
        redirect_to events_url, alert: "Musisz się zalogować!"
      end 
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:title, :allday, :start_date, :end_date, :color, :url_action, :user_id)
    end
end
