class Families::FamilyRotationsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_back_if_dont_can_change_rotation, only: [:edit, :update, :destroy]
  before_action :redirect_back_if_dont_can_add_rotation, only: [:new, :create, :duplicate]

  # POST
  def datatables_index
    respond_to do |format|
      format.json{ render json: FamilyFamilyRotationsDatatable.new(view_context, { only_for_current_family_id: params[:family_id] }) }
    end
  end

  # dla agenta
  # GET /insurances/:insurance_id/rotations/1/pdf_list_insureds
  def pdf_list_insureds
    @family = load_family
    @family_rotation = load_family_rotation

    respond_to do |format|
      format.pdf do
        pdf = ListFamilyInsuredsPdf.new(@family_rotation, view_context)
        send_data pdf.render,
        filename: "#{@family.number}_rotation_#{@family_rotation.rotation_date.strftime("%Y-%m-%d")}_list_insureds.pdf",
        type: "application/pdf",
        disposition: "inline"        
      end
    end 
  end

  # GET /insurances/:insurance_id/rotations/1/pdf_declarations_accession
  def pdf_declarations_accession
    @family = load_family
    @family_rotation = load_family_rotation

    case params[:prnscope]
    when 'A'  # tylko włączenia
      @family_coverages = @family_rotation.family_coverages_add.joins(:family_rotation, :insured).references(:family_rotation, :insured).order("individuals.last_name, individuals.last_name, individuals.address_city").all
    when 'B'  # wszystko
      @family_coverages = FamilyCoverage.joins(:family_rotation, :insured).by_family_rotation(@family_rotation.id).references(:family_rotation, :insured).order("individuals.last_name, individuals.last_name, individuals.address_city").all
    end 

    respond_to do |format|
      format.pdf do
        pdf = DeclarationsFamilyAccessionPdf.new(@family_coverages, view_context)
        send_data pdf.render,
        filename: "#{@family.number}_rotation_#{@family_rotation.rotation_date.strftime("%Y-%m-%d")}_declarations_accession.pdf",
        type: "application/pdf",
        disposition: "inline"        
      end
    end 
  end

  # dla firmy
  # GET /insurances/:insurance_id/rotations/1/pdf_list_payers
  def pdf_list_payers
    @family = load_family
    @family_rotation = load_family_rotation

    respond_to do |format|
      format.pdf do
        pdf = ListFamilyPayersPdf.new(@family_rotation, view_context)
        send_data pdf.render,
        filename: "#{@family.number}_rotation_#{@family_rotation.rotation_date.strftime("%Y-%m-%d")}_list_payers.pdf",
        type: "application/pdf",
        disposition: "inline"        
      end
    end 
  end

  def pdf_declarations_payers
    @family = load_family
    @family_rotation = load_family_rotation

    respond_to do |format|
      format.pdf do
        pdf = DeclarationsFamilyPayersPdf.new(@family_rotation, view_context)
        send_data pdf.render,
        filename: "#{@family.number}_rotation_#{@family_rotation.rotation_date.strftime("%Y-%m-%d")}_declarations_payers.pdf",
        type: "application/pdf",
        disposition: "inline"        
      end
    end 
  end

  # GET /families/:family_id/family_rotations/1
  # GET /families/:family_id/family_rotations/1.json
  def show
    @family = load_family
    @family_rotation = load_family_rotation

    respond_to do |format|
      format.html
      format.json
    end 
  end

  def new
    @family_rotation = FamilyRotation.new
    @family ||= load_family
    @family_rotation.family = @family

    respond_to do |format|
      format.html { render :new, locals: { duplicate_family_rotation: nil} } 
    end
  end

  def edit
    #@family ||= load_family
    #@family_rotation ||= load_family_rotation # "||=" a nie "=" ponieważ ładuję w czasie "redirect_back_if_dont_can_edit"

    respond_to do |format|
      format.html 
    end
  end

  def duplicate
    @for_duplicate ||= load_family_rotation
    @family_rotation = FamilyRotation.new(@for_duplicate.attributes)
    @family_rotation.rotation_lock = false
    @family_rotation.rotation_date = Time.zone.today
    @family ||= load_family
    @family_rotation.family = @family

    respond_to do |format|
      flash.now[:notice] = t('activerecord.messages.notice.rotation_duplicate', data: @for_duplicate.fullname)
      format.html { render :new, locals: { duplicate_family_rotation: @for_duplicate.id} }  
    end
  end

  def create
    #@family ||= load_family
    @family_rotation = FamilyRotation.new(family_rotation_params)
    @family_rotation.family = @family
    
    respond_to do |format|
      if @family_rotation.save
        @family_rotation.duplicate_coverages(params[:duplicate_family_rotation]) if (params[:duplicate_family_rotation]).present? # dodaj osoby jezeli wykonujesz duplikat

        format.html { redirect_to family_family_rotation_path(@family, @family_rotation), success: t('activerecord.messages.successfull.created', data: @family_rotation.fullname) }
        format.json { render :show, status: :created, location: @family_rotation }
      else
        format.html { render :new, locals: { duplicate_family_rotation: params[:duplicate_family_rotation]} }
        format.json { render json: @family_rotation.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    #@family = load_family
    #@family_rotation = load_family_rotation

    respond_to do |format|
      if @family_rotation.update(family_rotation_params)
        format.html { redirect_to family_family_rotation_path(@family, @family_rotation), success: t('activerecord.messages.successfull.updated', data: @family_rotation.fullname) }
        format.json { render :show, status: :ok, location: @family_rotation }
      else
        format.html { render :edit }
        format.json { render json: @family_rotation.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    #@family = load_family
    #@family_rotation ||= load_family_rotation # "||=" a nie "=" ponieważ ładuję w czasie "redirect_back_if_dont_can_edit"

    if @family_rotation.destroy
      redirect_to family_path(@family), success: t('activerecord.messages.successfull.destroyed', data: @family_rotation.fullname)
    else 
      flash[:error] = t('activerecord.messages.error.destroyed', data: @family_rotation.fullname)
      render :show
    end      
  end

  def lock
    @family_rotation = load_family_rotation 
    @family = load_family

    if @family_rotation.lock
      redirect_to family_family_rotation_path(@family, @family_rotation), success: t('activerecord.messages.successfull.locking_rotation', data: @family_rotation.rotation_date)
    else 
      flash.now[:error] = t('activerecord.messages.error.locking_rotation', data: @family_rotation.rotation_date)
      render :show 
    end         
  end

  def unlock
    @family_rotation = load_family_rotation 
    @family = load_family

    if @family_rotation.unlock
      redirect_to family_family_rotation_path(@family, @family_rotation), success: t('activerecord.messages.successfull.unlocking_rotation', data: @family_rotation.rotation_date)
    else 
      flash.now[:error] = t('activerecord.messages.error.unlocking_rotation', data: @family_rotation.rotation_date)
      render :show 
    end         
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def load_family_rotation
      FamilyRotation.find(params[:id])
    end

    def load_family
      Family.find(params[:family_id])
    end

    def redirect_back_if_dont_can_change_rotation
      @family ||= load_family
      @family_rotation ||= load_family_rotation
      redirect_to family_family_rotation_path(@family, @family_rotation), alert: "Polisa lub Rotacja jest zablokowana!" if (@family_rotation.rotation_lock? || @family_rotation.family.family_lock?)      
    end

    def redirect_back_if_dont_can_add_rotation
      @family ||= load_family
      redirect_to family_path(@family), alert: "Polisa jest zablokowana!" if @family.family_lock?      
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def family_rotation_params
      params.require(:family_rotation).permit(:rotation_date, :rotation_lock, :date_send_file, :note, :family_id)
    end
end
