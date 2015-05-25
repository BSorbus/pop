class Insurances::RotationsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_back_if_dont_can_edit_rotation, only: [:edit, :destroy]

  # POST
  def datatables_index
    respond_to do |format|
      format.json{ render json: InsuranceRotationsDatatable.new(view_context, { only_for_current_insurance_id: params[:insurance_id] }) }
    end
  end

  # dla centrali
  # GET /insurances/1/pdf_list_benefits_nnw1
  def pdf_list_benefits_nnw1
    @insurance = load_insurance
    @rotation = load_rotation

    respond_to do |format|
      format.pdf do
        pdf = ListBenefitsNNW1Pdf.new(@rotation, view_context)
        send_data pdf.render,
        filename: "#{@insurance.number}_list_benefits_nnw1.pdf",
        type: "application/pdf",
        disposition: "inline"        
      end
    end 
  end

  # GET /insurances/:insurance_id/rotations/1/pdf_list_insureds_nnw2
  def pdf_list_insureds_nnw2
    @insurance = load_insurance
    @rotation = load_rotation

    respond_to do |format|
      format.pdf do
        pdf = ListInsuredsNNW2Pdf.new(@rotation, view_context)
        send_data pdf.render,
        filename: "#{@insurance.number}_rotation_#{@rotation.rotation_date.strftime("%Y-%m-%d")}_list_insureds_nnw2.pdf",
        type: "application/pdf",
        disposition: "inline"        
      end
    end 
  end

  # GET /insurances/:insurance_id/rotations/1/pdf_groups_with_insureds_add
  def pdf_groups_with_insureds_add
    @insurance = load_insurance
    @rotation = load_rotation

    respond_to do |format|
      format.pdf do
        pdf = GroupsWithInsuredsPdf.new(@rotation, view_context, "A")
        send_data pdf.render,
        filename: "#{@insurance.number}_rotation_#{@rotation.rotation_date.strftime("%Y-%m-%d")}_groups_with_insureds_add.pdf",
        type: "application/pdf",
        disposition: "inline"        
      end
    end 
  end

  # GET /insurances/:insurance_id/rotations/1/pdf_groups_with_insureds_add
  def pdf_groups_with_insureds_remove
    @insurance = load_insurance
    @rotation = load_rotation

    respond_to do |format|
      format.pdf do
        pdf = GroupsWithInsuredsPdf.new(@rotation, view_context, "R")
        send_data pdf.render,
        filename: "#{@insurance.number}_rotation_#{@rotation.rotation_date.strftime("%Y-%m-%d")}_groups_with_insureds_remove.pdf",
        type: "application/pdf",
        disposition: "inline"        
      end
    end 
  end

  # dla agenta
  # GET /insurances/:insurance_id/rotations/1/pdf_list_insureds
  def pdf_list_insureds
    @insurance = load_insurance
    @rotation = load_rotation

    respond_to do |format|
      format.pdf do
        pdf = ListInsuredsPdf.new(@rotation, view_context)
        send_data pdf.render,
        filename: "#{@insurance.number}_rotation_#{@rotation.rotation_date.strftime("%Y-%m-%d")}_list_insureds.pdf",
        type: "application/pdf",
        disposition: "inline"        
      end
    end 
  end

  # GET /insurances/:insurance_id/rotations/1/pdf_declarations_accession
  def pdf_declarations_accession1
    @insurance = load_insurance
    @rotation = load_rotation

    case params[:prnscope]
    when 'A'  # tylko włączenia
      @coverages = @rotation.coverages_add.joins(:rotation, :insured, :group).references(:rotation, :insured, :group).order("individuals.last_name, individuals.last_name, individuals.address_city").all
    when 'B'  # wszystko
      @coverages = Coverage.joins(:rotation, :insured, :group).by_rotation(@rotation.id).references(:rotation, :insured, :group).order("individuals.last_name, individuals.last_name, individuals.address_city").all
    end 

    respond_to do |format|
      format.pdf do
        pdf = DeclarationsAccession1Pdf.new(@coverages, view_context)
        send_data pdf.render,
        filename: "#{@insurance.number}_rotation_#{@rotation.rotation_date.strftime("%Y-%m-%d")}_declarations_accession1.pdf",
        type: "application/pdf",
        disposition: "inline"        
      end
    end 
  end

  def pdf_declarations_accession2
    # zostawiam tak jako przyklad przekazywania parametru. Prawidlowo winno byc jak wyzej
    @insurance = load_insurance
    @rotation = load_rotation

    respond_to do |format|
      format.pdf do
        pdf = DeclarationsAccession2Pdf.new(@rotation, view_context, params[:prnscope])
        send_data pdf.render,
        filename: "#{@insurance.number}_rotation_#{@rotation.rotation_date.strftime("%Y-%m-%d")}_declarations_accession2.pdf",
        type: "application/pdf",
        disposition: "inline"        
      end
    end 
  end


  # dla firmy
  # GET /insurances/:insurance_id/rotations/1/pdf_list_payers
  def pdf_list_payers
    @insurance = load_insurance
    @rotation = load_rotation

    respond_to do |format|
      format.pdf do
        pdf = ListPayersPdf.new(@rotation, view_context)
        send_data pdf.render,
        filename: "#{@insurance.number}_rotation_#{@rotation.rotation_date.strftime("%Y-%m-%d")}_list_payers.pdf",
        type: "application/pdf",
        disposition: "inline"        
      end
    end 
  end

  # GET /insurances/:insurance_id/rotations/1/pdf_declarations_payers
  def pdf_declarations_payers
    @insurance = load_insurance
    @rotation = load_rotation

    respond_to do |format|
      format.pdf do
        pdf = DeclarationsPayersPdf.new(@rotation, view_context)
        send_data pdf.render,
        filename: "#{@insurance.number}_rotation_#{@rotation.rotation_date.strftime("%Y-%m-%d")}_declarations_payers.pdf",
        type: "application/pdf",
        disposition: "inline"        
      end
    end 
  end

  # dla ubezpieczonego
  # GET /insurances/:insurance_id/rotations/1/pdf_certifications_insureds
  def pdf_certifications_insureds
    @insurance = load_insurance
    @rotation = load_rotation

    case params[:prnscope]
    when 'A'  # tylko włączenia
      @coverages = @rotation.coverages_add.joins(:rotation, :insured, :group).references(:rotation, :insured, :group).order("individuals.last_name, individuals.last_name, individuals.address_city").all
    when 'B'  # wszystko
      @coverages = Coverage.joins(:rotation, :insured, :group).by_rotation(@rotation.id).references(:rotation, :insured, :group).order("individuals.last_name, individuals.last_name, individuals.address_city").all
    end  

    respond_to do |format|
      format.pdf do
        pdf = CertificationsInsuredsPdf.new(@coverages, view_context)
        send_data pdf.render,
        filename: "#{@insurance.number}_rotation_#{@rotation.rotation_date.strftime("%Y-%m-%d")}_certifications_insureds.pdf",
        type: "application/pdf",
        disposition: "inline"        
      end
    end 
  end

  # GET /insurances/:insurance_id/rotations/1/pdf_dispositions_insureds
  def pdf_dispositions_insureds
    @insurance = load_insurance
    @rotation = load_rotation

    case params[:prnscope]
    when 'A'  # tylko włączenia
      @coverages = @rotation.coverages_add.joins(:rotation, :insured, :group).references(:rotation, :insured, :group).order("individuals.last_name, individuals.last_name, individuals.address_city").all
    when 'B'  # wszystko
      @coverages = Coverage.joins(:rotation, :insured, :group).by_rotation(@rotation.id).references(:rotation, :insured, :group).order("individuals.last_name, individuals.last_name, individuals.address_city").all
    end  

    respond_to do |format|
      format.pdf do
        pdf = DispositionsInsuredsPdf.new(@coverages, view_context)
        send_data pdf.render,
        filename: "#{@insurance.number}_rotation_#{@rotation.rotation_date.strftime("%Y-%m-%d")}_dispositions_insureds.pdf",
        type: "application/pdf",
        disposition: "inline"        
      end
    end 
  end

  # GET /insurances/:insurance_id/rotations/1
  # GET /insurances/:insurance_id/rotations/1.json
  def show
    @insurance = load_insurance
    @rotation = load_rotation

    respond_to do |format|
      format.html
      format.json
    end 
  end

  # GET /rotations/new
  def new
    @rotation = Rotation.new
    @insurance = load_insurance
    @rotation.insurance = @insurance

    respond_to do |format|
      format.html { render :new, locals: { duplicate_rotation: nil} } 
    end
  end

  # GET /insurances/:insurance_id/rotations/1/edit
  def edit
    @insurance = load_insurance
    @rotation ||= load_rotation # "||=" a nie "=" ponieważ ładuję w czasie "redirect_back_if_dont_can_edit"

    # wariant II bez użycia before_action
    #redirect_back_if_dont_can_edit_rotation and return

    respond_to do |format|
      format.html 
    end
  end

  # GET /insurances/:insurance_id/rotations/1/edit
  def duplicate
    @for_duplicate = load_rotation
    @rotation = Rotation.new(@for_duplicate.attributes)
    @rotation.rotation_lock = false
    @rotation.rotation_date = Time.zone.today
    @insurance = load_insurance
    @rotation.insurance = @insurance

    respond_to do |format|
      flash.now[:notice] = t('activerecord.messages.notice.rotation_duplicate', data: @for_duplicate.fullname)
      format.html { render :new, locals: { duplicate_rotation: @for_duplicate.id} }  
    end
  end

  # POST /insurances/:insurance_id/rotations
  # POST /insurances/:insurance_id/rotations.json
  def create
    @insurance = load_insurance
    @rotation = Rotation.new(rotation_params)
    @rotation.insurance = @insurance
    
    respond_to do |format|
      if @rotation.save
        @rotation.duplicate_coverages(params[:duplicate_rotation]) if !(params[:duplicate_rotation]).blank? # dodaj osoby jezeli wykonujesz duplikat

        format.html { redirect_to insurance_rotation_path(@insurance, @rotation), success: t('activerecord.messages.successfull.created', data: @rotation.fullname) }
        format.json { render :show, status: :created, location: @rotation }
      else
        format.html { render :new, locals: { duplicate_rotation: params[:duplicate_rotation]} }
        format.json { render json: @rotation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /insurances/:insurance_id/rotations/1
  # PATCH/PUT /insurances/:insurance_id/rotations/1.json
  def update
    @insurance = load_insurance
    @rotation = load_rotation

    respond_to do |format|
      if @rotation.update(rotation_params)
        format.html { redirect_to insurance_rotation_path(@insurance, @rotation), success: t('activerecord.messages.successfull.updated', data: @rotation.fullname) }
        format.json { render :show, status: :ok, location: @rotation }
      else
        format.html { render :edit }
        format.json { render json: @rotation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /insurances/:insurance_id/rotations/1
  # DELETE /insurances/:insurance_id/rotations/1.json
  def destroy
    @insurance = load_insurance
    @rotation ||= load_rotation # "||=" a nie "=" ponieważ ładuję w czasie "redirect_back_if_dont_can_edit"

    # wariant II bez użycia before_action
    #redirect_back_if_dont_can_edit_rotation and return

    if @rotation.destroy
      redirect_to insurance_path(@insurance), success: t('activerecord.messages.successfull.destroyed', data: @rotation.fullname)
    else 
      flash[:error] = t('activerecord.messages.error.destroyed', data: @rotation.fullname)
      render :show
    end      
  end

  # GET /insurances/:insurance_id/rotations/1/export_coverages_current.csv
  def export_coverages_current
    @rotation = load_rotation
    @insurance = load_insurance

    @data = @rotation.coverages.joins(:rotation, :insured, :group)
      .by_rotation(@rotation.id)
      .references(:rotation, :insured, :group)
      .order("groups.number, individuals.last_name, individuals.last_name, individuals.address_city").all
  
    respond_to do |format|
      format.html { redirect_to root_url }
      format.csv { send_data @data.to_csv_as_nu, filename: "NU_#{@insurance.number.last(12)}_#{@rotation.rotation_date.strftime("%Y%m%d").last(6)}.txt" }
    end
  end

  # GET /insurances/:insurance_id/rotations/1/export_coverages_add_remove.csv
  def export_coverages_add_remove
    @rotation = load_rotation
    @insurance = load_insurance

    @data = @rotation.coverages_add.joins(:rotation, :insured, :group)
      .references(:rotation, :insured, :group)
      .order("groups.number, individuals.last_name, individuals.last_name, individuals.address_city").all
  
    @data_remove = @rotation.coverages_remove.joins(:rotation, :insured, :group)
      .references(:rotation, :insured, :group)
      .order("groups.number, individuals.last_name, individuals.last_name, individuals.address_city").all
  
    # koniec ochrony dla wcześniejszej rotacji.
    date_end_previous_rotation = @rotation.rotation_date - 1.days

    respond_to do |format|
      format.html { redirect_to root_url }
      format.csv { send_data @data.to_csv_add_remove(@data, @data_remove, date_end_previous_rotation), 
                   filename: "N_#{@insurance.number.last(12)}_#{@rotation.rotation_date.strftime("%Y%m%d").last(6)}.txt" }
    end
  end

  def lock
    @rotation = load_rotation 
    @insurance = load_insurance

    if @rotation.lock
      redirect_to insurance_rotation_path(@insurance, @rotation), success: t('activerecord.messages.successfull.locking_rotation', data: @rotation.rotation_date)
    else 
      flash.now[:error] = t('activerecord.messages.error.locking_rotation', data: @rotation.rotation_date)
      render :show 
    end         
  end

  def unlock
    @rotation = load_rotation 
    @insurance = load_insurance

    if @rotation.unlock
      redirect_to insurance_rotation_path(@insurance, @rotation), success: t('activerecord.messages.successfull.unlocking_rotation', data: @rotation.rotation_date)
    else 
      flash.now[:error] = t('activerecord.messages.error.unlocking_rotation', data: @rotation.rotation_date)
      render :show 
    end         
  end

  private
    def load_rotation
      Rotation.find(params[:id])
    end

    def load_insurance
      Insurance.find(params[:insurance_id])
    end

    def redirect_back_if_dont_can_edit_rotation
      @rotation = load_rotation
      redirect_to :back, alert: "Rotacja jest zablokowana!" if @rotation.rotation_lock?      
      # wariant II 
      # wyłącz filtr before_action i odkomentuj redirect_back.... w akcji :edit
      #redirect_to :back, alert: "Akcja zabroniona - Rotacja jest zablokowana!" and return true if @rotation.rotation_lock?      
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rotation_params
      params.require(:rotation).permit(:rotation_date, :rotation_lock, :date_file_send, :note, :insurance_id)
    end
end
