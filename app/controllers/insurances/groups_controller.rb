class Insurances::GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_back_if_dont_can_edit_group, only: [:edit, :destroy]

  # POST
  def datatables_index
    respond_to do |format|
      format.json{ render json: InsuranceGroupsDatatable.new(view_context, { only_for_current_insurance_id: params[:insurance_id] }) }
    end
  end

  # GET /insurances/:insurance_id/groups/1
  # GET /insurances/:insurance_id/groups/1.json
  def show
    @insurance = load_insurance
    @group = load_group

    respond_to do |format|
      format.html
      format.json
      format.pdf do
        pdf = GroupPdf.new(@group, view_context)
        send_data pdf.render,
        filename: "#{@group.insurance.number}_grupa_#{@group.number}.pdf",
        type: "application/pdf",
        disposition: "inline"        
      end
    end
  end

  # GET /insurances/:insurance_id/groups/new
  def new
    @group = Group.new
    @insurance = load_insurance
    @group.insurance = @insurance

    respond_to do |format|
      format.html { render :new, locals: { duplicate_group: nil} } 
    end
  end

  # GET /insurances/:insurance_id/groups/1/edit
  def edit
    @insurance = load_insurance
    @group ||= load_group # "||=" a nie "=" ponieważ ładuję w czasie "redirect_back_if_dont_can_edit"

    respond_to do |format|
      format.html
    end
  end

  # GET /insurances/:insurance_id/groups/1/edit
  def duplicate
    @for_duplicate = load_group
    @group = Group.new(@for_duplicate.attributes)
    @insurance = load_insurance
    @group.insurance = @insurance

    respond_to do |format|
     flash.now[:notice] = t('activerecord.messages.notice.group_duplicate', data: @for_duplicate.fullname)
     format.html { render :new, locals: { duplicate_group: @for_duplicate.id} }  
    end
  end

  # POST /insurances/:insurance_id/groups
  # POST /insurances/:insurance_id/groups.json
  def create
    @insurance = load_insurance
    @group = Group.new(group_params)
    @group.insurance = @insurance

    respond_to do |format|
      if @group.save
        @group.set_group_values if (@group.quotation != 'C') # Nie wyliczaj automatycznie składek dla kwotacji Niestandardowej
        @group.duplicate_discounts(params[:duplicate_group]) if !(params[:duplicate_group]).nil? # dodaj znizki jezeli wykonujesz duplikat
        
        format.html { redirect_to insurance_group_path(@insurance, @group), success: t('activerecord.messages.successfull.created', data: @group.fullname) }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new, locals: { duplicate_group: params[:duplicate_group]} }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /insurances/:insurance_id/groups/1
  # PATCH/PUT /insurances/:insurance_id/groups/1.json
  def update
    @insurance = load_insurance
    @group = load_group

    respond_to do |format|
      @group.assign_attributes(group_params)
      @group.set_group_values if (@group.quotation != 'C') # Nie wyliczaj automatycznie składek dla kwotacji Niestandardowej

#      if @group.update(group_params)
      if @group.save
        format.html { redirect_to insurance_group_path(@insurance, @group), success: t('activerecord.messages.successfull.updated', data: @group.fullname) }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /insurances/:insurance_id/groups/1
  # DELETE /insurances/:insurance_id/groups/1.json
  def destroy
    @insurance = load_insurance
    @group ||= load_group # "||=" a nie "=" ponieważ ładuję w czasie "redirect_back_if_dont_can_edit"

    if @group.destroy
      redirect_to insurance_path(@insurance), success: t('activerecord.messages.successfull.destroyed', data: @group.fullname)
    else 
      flash[:error] = t('activerecord.messages.error.destroyed', data: @group.fullname)
      render :show
    end      
  end

  private

    def load_group
      Group.find(params[:id])
    end

    def load_insurance
      Insurance.find(params[:insurance_id])
    end

    def redirect_back_if_dont_can_edit_group
      @group ||= load_group
      redirect_to :back, alert: "Grupa użyta w zablokowanej Rotacji!" if @group.group_used_in_locked_rotation 
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:number, :quotation, :tariff_fixed, :full_range, :risk_group, :assurance, :assurance_component, :treatment, :treatment_component, :ambulatory, :ambulatory_component, :hospital, :hospital_component, :infarct, :infarct_component, :inability, :inability_component, :death_100_percent, :sum_component, :sum_after_discounts, :sum_after_increases, :sum_after_monthly, :insurance_id)
    end
end
