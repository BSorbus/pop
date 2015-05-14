class InsurancesController < ApplicationController
  before_action :authenticate_user!


  # GET /insurances
  # GET /insurances.json
  def index
    respond_to do |format|
      format.html
    end
  end

  # POST /insurances
  def datatables_index
    respond_to do |format|
      format.json{ render json: InsuranceDatatable.new(view_context, { only_for_current_user_id: current_user.id }) }
    end
  end

  # POST /insurances
  def datatables_index_company
    respond_to do |format|
      format.json{ render json: CompanyInsurancesDatatable.new(view_context, { only_for_current_company_id: params[:company_id] }) }
    end
  end

  # dla centrali
  # GET /insurances/1/pdf_list_benefits_nnw1
  def pdf_list_benefits_nnw1
    @insurance = load_insurance
    @rotation = @insurance.rotations.last

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

  # GET /insurances/1/pdf_list_insureds_nnw2
  def pdf_list_insureds_nnw2
    @insurance = load_insurance
    @rotation = @insurance.rotations.last

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
    @rotation = @insurance.rotations.last

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
    @rotation = @insurance.rotations.last

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
  # GET /insurances/1/pdf_list_insureds
  def pdf_list_insureds
    @insurance = load_insurance
    @rotation = @insurance.rotations.last

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

  # GET /insurances/1/pdf_declarations_accession
  def pdf_declarations_accession1
    @insurance = load_insurance
    @rotation = @insurance.rotations.last

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
    @rotation = @insurance.rotations.last

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
  # GET /insurances/1/pdf_list_of_payers
  def pdf_list_payers
    @insurance = load_insurance
    @rotation = @insurance.rotations.last

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

  # GET /insurances/1/pdf_declarations_payers
  def pdf_declarations_payers
    @insurance = load_insurance
    @rotation = @insurance.rotations.last

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
  # GET /insurances/1/pdf_certifications_insureds
  def pdf_certifications_insureds
    @insurance = load_insurance
    @rotation = @insurance.rotations.last

    case params[:prnscope]
    when 'A'  # tylko włączenia
      @coverages = @rotation.coverages_add.joins(:rotation, :insured, :group).references(:rotation, :insured, :group).order("individuals.last_name, individuals.last_name, individuals.address_city").all
    when 'B'  # tylko włączenia
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

  # GET /insurances/1/pdf_dispositions_insureds
  def pdf_dispositions_insureds
    @insurance = load_insurance
    @rotation = @insurance.rotations.last

    case params[:prnscope]
    when 'A'  # tylko włączenia
      @coverages = @rotation.coverages_add.joins(:rotation, :insured, :group).references(:rotation, :insured, :group).order("individuals.last_name, individuals.last_name, individuals.address_city").all
    when 'B'  # tylko włączenia
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

  # GET /insurances/1
  # GET /insurances/1.json
  def show
    @insurance = load_insurance

    respond_to do |format|
      format.html
      format.json
    end 
  end

  # GET /insurances/new
  def new
    @insurance = Insurance.new
    @insurance.user = current_user
    @company = load_company
    @insurance.company = @company

    respond_to do |format|
      format.html
    end
  end

  # GET /insurances/1/edit
  def edit
    @insurance = load_insurance

    respond_to do |format|
      format.html
    end
  end

  # POST /insurances
  # POST /insurances.json
  def create
    @insurance = Insurance.new(insurance_params)
    @insurance.user = current_user

    respond_to do |format|
      if @insurance.save
        format.html { redirect_to @insurance, success: t('activerecord.messages.successfull.created', data: @insurance.number) }
        format.json { render :show, status: :created, location: @insurance }
      else
        format.html { render :new }
        format.json { render json: @insurance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /insurances/1
  # PATCH/PUT /insurances/1.json
  def update
    @insurance = load_insurance

    respond_to do |format|
      if @insurance.update(insurance_params)
        format.html { redirect_to @insurance, success: t('activerecord.messages.successfull.updated', data: @insurance.number) }
        format.json { render :show, status: :ok, location: @insurance }
      else
        format.html { render :edit }
        format.json { render json: @insurance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /insurances/1
  # DELETE /insurances/1.json
  def destroy
    @insurance = load_insurance 

    if @insurance.destroy
      redirect_to insurances_url, success: t('activerecord.messages.successfull.destroyed', data: @insurance.number)
    else 
      flash[:error] = t('activerecord.messages.error.destroyed', data: @insurance.number)
      render :show
    end      
  end

  # GET /insurances/1/export_coverages_current
  def export_coverages_current
    @insurance = load_insurance
    @rotation = @insurance.rotations.last

    @data = @rotation.coverages.joins(:rotation, :insured, :group)
      .by_rotation(@rotation.id)
      .references(:rotation, :insured, :group)
      .order("groups.number, individuals.last_name, individuals.last_name, individuals.address_city").all
  
    respond_to do |format|
      format.html { redirect_to root_url }
      format.csv { send_data @data.to_csv_as_nu, filename: "NU_#{@insurance.number.last(12)}_#{@rotation.rotation_date.strftime("%Y%m%d").last(6)}.txt" }
    end
  end

  # GET /insurances/1/export_coverages_add_remove.csv
  def export_coverages_add_remove
    @insurance = load_insurance
    @rotation = @insurance.rotations.last

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

  def numbering_groups
    @insurance = load_insurance 

    if @insurance.reorganize_group_numbers
      redirect_to @insurance, success: t('activerecord.messages.successfull.numbering', data: @insurance.number)
    else 
      flash[:error] = t('activerecord.messages.error.numbering', data: @insurance.number)
      render :show 
    end         

    # wywołanie funkcji JS, by nie odświeżać całej strony
    #@insurance.reorganize_group_numbers
    #flash.now[:notice] = t('activerecord.messages.successfull.numbering', data: @insurance.number)
    #flash[:notice] = t('activerecord.messages.successfull.numbering', data: @insurance.number)
    #render :nothing => true and return
  end

  private
    def load_insurance
      Insurance.by_user(current_user.id).find(params[:id])
    end

    def load_company
      Company.find(params[:company_id]) if !(params[:company_id]).nil?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def insurance_params
      params.require(:insurance).permit(:number, :concluded, :valid_from, :applies_to, :pay, :discounts_lock, :note, :company_id, :inputWalls)
    end
end
