class IndividualsController < ApplicationController
  before_action :authenticate_user!


  # GET /individuals
  # GET /individuals.json
  def index
    respond_to do |format|
      format.html
    end   
  end

  # POST /individuals
  def datatables_index
    respond_to do |format|
      format.json{ render json: IndividualDatatable.new(view_context, { only_for_current_user_id: current_user.id }) } 
    end   
  end

  def select2_index
    params[:q] = (params[:q]).upcase
    @individuals = Individual.order(:last_name, :first_name).finder_by_user(params[:q], current_user.id)
    @individuals_on_page = @individuals.page(params[:page]).per(params[:page_limit])

    respond_to do |format|
      format.html
      format.json { 
        render json: { 
          individuals: @individuals_on_page.as_json([]),
          total_count: @individuals.count 
        } 
      }
    end
  end

  # dla agenta
  def pdf_declarations_accession1
    @coverages_all = Coverage.joins(:rotation, :insured).by_insured(params[:id]).references(:rotation, :insured).order("rotations.rotation_date").all

    if @coverages_all.empty?
      redirect_to :back, alert: t('activerecord.messages.notice.no_insured') and return
    else
      @rotation = @coverages_all.last.rotation 
      @insurance = @rotation.insurance
      # jeden rekord
      @coverage = Coverage.joins(:rotation, :insured).by_insured(params[:id]).by_rotation(@rotation.id).all

      respond_to do |format|
        format.pdf do
          pdf = DeclarationsAccession1Pdf.new(@coverage, view_context)
          send_data pdf.render,
          filename: "#{@insurance.number}_rotation_#{@rotation.rotation_date.strftime("%Y-%m-%d")}_declarations_accession1.pdf",
          type: "application/pdf",
          disposition: "inline"        
        end
      end
    end 
  end

  def pdf_declarations_accession2
    @coverages_all = Coverage.joins(:rotation, :insured).by_insured(params[:id]).references(:rotation, :insured).order("rotations.rotation_date").all

    if @coverages_all.empty?
      redirect_to :back, alert: t('activerecord.messages.notice.no_insured') and return
    else
      @rotation = @coverages_all.last.rotation 
      @insurance = @rotation.insurance
      # jeden rekord
      @coverage = Coverage.joins(:rotation, :insured).by_insured(params[:id]).by_rotation(@rotation.id).all

      respond_to do |format|
        format.pdf do
          pdf = DeclarationsAccession2Pdf.new(@coverage, view_context)
          send_data pdf.render,
          filename: "#{@insurance.number}_rotation_#{@rotation.rotation_date.strftime("%Y-%m-%d")}_declarations_accession2.pdf",
          type: "application/pdf",
          disposition: "inline"        
        end
      end
    end 
  end

  # dla ubezpieczonego
  # GET /individuals/1/pdf_certifications_insureds
  def pdf_certifications_insureds
    @coverages_all = Coverage.joins(:rotation, :insured).by_insured(params[:id]).references(:rotation, :insured).order("rotations.rotation_date").all

    if @coverages_all.empty?
      redirect_to :back, alert: t('activerecord.messages.notice.no_insured') and return
    else
      @rotation = @coverages_all.last.rotation 
      @insurance = @rotation.insurance
      # jeden rekord
      @coverage = Coverage.joins(:rotation, :insured).by_insured(params[:id]).by_rotation(@rotation.id).all

      respond_to do |format|
        format.pdf do
          pdf = CertificationsInsuredsPdf.new(@coverage, view_context)
          send_data pdf.render,
          filename: "#{@insurance.number}_rotation_#{@rotation.rotation_date.strftime("%Y-%m-%d")}_certifications_insureds.pdf",
          type: "application/pdf",
          disposition: "inline"        
        end
      end 
    end
  end

  # GET /individuals/1/pdf_dispositions_insureds
  def pdf_dispositions_insureds
    @coverages_all = Coverage.joins(:rotation, :insured).by_insured(params[:id]).references(:rotation, :insured).order("rotations.rotation_date").all

    if @coverages_all.empty?
      redirect_to :back, alert: t('activerecord.messages.notice.no_insured') and return
    else
      @rotation = @coverages_all.last.rotation 
      @insurance = @rotation.insurance
      # jeden rekord
      @coverage = Coverage.joins(:rotation, :insured).by_insured(params[:id]).by_rotation(@rotation.id).all

      respond_to do |format|
        format.pdf do
          pdf = DispositionsInsuredsPdf.new(@coverage, view_context)
          send_data pdf.render,
          filename: "#{@insurance.number}_rotation_#{@rotation.rotation_date.strftime("%Y-%m-%d")}_dispositions_insureds.pdf",
          type: "application/pdf",
          disposition: "inline"        
        end
      end 
    end
  end

  # family
  # dla agenta
  def pdf_declarations_family_accession
    @family_coverages_all = FamilyCoverage.joins(:family_rotation, :insured).by_insured(params[:id]).references(:family_rotation, :insured).order("family_rotations.rotation_date").all

    if @family_coverages_all.empty?
      redirect_to :back, alert: t('activerecord.messages.notice.no_insured') and return
    else
      @family_rotation = @family_coverages_all.last.family_rotation 
      @family = @family_rotation.family
      # jeden rekord
      @family_coverage = FamilyCoverage.joins(:family_rotation, :insured).by_insured(params[:id]).by_family_rotation(@family_rotation.id).all

      respond_to do |format|
        format.pdf do
          pdf = DeclarationsFamilyAccessionPdf.new(@family_coverage, view_context)
          send_data pdf.render,
          filename: "#{@family.number}_rotation_#{@family_rotation.rotation_date.strftime("%Y-%m-%d")}_declarations_accession.pdf",
          type: "application/pdf",
          disposition: "inline"        
        end
      end
    end 
  end

  # GET /individuals/1
  # GET /individuals/1.json
  def show
    @individual = load_individual

    respond_to do |format|
      format.html
      format.json
    end 
  end

  # GET /individuals/new
  def new
    @individual = Individual.new
    @individual.user = current_user

    respond_to do |format|
      format.html
    end
  end

  # GET /individuals/1/edit
  def edit
    @individual = load_individual

    respond_to do |format|
      format.html
    end
  end

  # POST /individuals
  # POST /individuals.json
  def create
    @individual = Individual.new(individual_params)
    @individual.user = current_user

    respond_to do |format|
      if @individual.save
        format.html { redirect_to @individual, success: t('activerecord.messages.successfull.created', data: @individual.fullname) }
        format.json { render :show, status: :created, location: @individual }
      else
        format.html { render :new }
        format.json { render json: @individual.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /individuals/1
  # PATCH/PUT /individuals/1.json
  def update
    @individual = load_individual

    respond_to do |format|
      if @individual.update(individual_params)
        format.html { redirect_to @individual, success: t('activerecord.messages.successfull.updated', data: @individual.fullname) }
        format.json { render :show, status: :ok, location: @individual }
      else
        format.html { render :edit }
        format.json { render json: @individual.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /individuals/1
  # DELETE /individuals/1.json
  def destroy
    @individual = load_individual    

    if @individual.destroy
      redirect_to individuals_url, success: t('activerecord.messages.successfull.destroyed', data: @individual.fullname) 
    else 
      flash[:error] = t('activerecord.messages.error.destroyed', data: @individual.fullname)
      render :show
    end      
  end

  private
    def load_individual
      Individual.by_user(current_user.id).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def individual_params
      params.require(:individual).permit(:first_name, :last_name, :address_city, :address_street, :address_house, :address_number, :address_postal_code, :pesel, :birth_date, :profession, :note, :user_id)
    end
end
