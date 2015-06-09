class FamiliesController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_back_if_dont_can_change_family, only: [:edit, :update, :destroy]

  # GET /families
  # GET /families.json
  def index
    respond_to do |format|
      format.html
    end
  end

  # POST /families
  def datatables_index
    respond_to do |format|
      format.json{ render json: FamilyDatatable.new(view_context, { only_for_current_user_id: current_user.id }) }
    end
  end


  def datatables_index_company
    respond_to do |format|
      format.json{ render json: CompanyFamiliesDatatable.new(view_context, { only_for_current_company_id: params[:company_id] }) }
    end
  end

  # GET /families/1
  # GET /families/1.json
  def show
    @family = load_family

    respond_to do |format|
      format.html
      format.json
    end 
  end

  # GET /families/new
  def new
    @family = Family.new
    @family.user = current_user
    @company = load_company
    @family.company = @company

    respond_to do |format|
      format.html { render :new } 
    end
  end

  # GET /families/1/edit
  def edit
    # @family = load_family

    respond_to do |format|
      format.html
    end
  end

  # POST /families
  # POST /families.json
  def create
    @family = Family.new(family_params)
    @family.user = current_user

    respond_to do |format|
      if @family.save
        format.html { redirect_to @family, success: t('activerecord.messages.successfull.created', data: @family.number) }
        format.json { render :show, status: :created, location: @family }
      else
        format.html { render :new }
        format.json { render json: @family.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /families/1
  # PATCH/PUT /families/1.json
  def update
    # @family = load_family

    respond_to do |format|
      if @family.update(family_params)
        format.html { redirect_to @family, success: t('activerecord.messages.successfull.updated', data: @family.number) }
        format.json { render :show, status: :ok, location: @family }
      else
        format.html { render :edit }
        format.json { render json: @family.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /families/1
  # DELETE /families/1.json
  def destroy
    # @family = load_family 

    if @family.destroy
      redirect_to families_url, success: t('activerecord.messages.successfull.destroyed', data: @family.number)
    else 
      flash[:error] = t('activerecord.messages.error.destroyed', data: @family.number)
      render :show
    end      
  end

  def lock
    @family = load_family

    if @family.lock
      redirect_to family_path(@family), success: t('activerecord.messages.successfull.locking_family', data: @family.number)
    else 
      flash.now[:error] = t('activerecord.messages.error.locking_family', data: @family.number)
      render :show 
    end         
  end

  def unlock
    @family = load_family

    if @family.unlock
      redirect_to family_path(@family), success: t('activerecord.messages.successfull.unlocking_family', data: @family.number)
    else 
      flash.now[:error] = t('activerecord.messages.error.unlocking_family', data: @family.number)
      render :show 
    end         
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def load_family
      Family.by_user(current_user.id).find(params[:id])
    end

    def load_company
      Company.find(params[:company_id]) if !(params[:company_id]).nil?
    end

    def redirect_back_if_dont_can_change_family
      @family ||= load_family
      redirect_to family_path(@family), alert: "Polisa jest zablokowana!" if @family.family_lock?      
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def family_params
      params.require(:family).permit(:number, :proposal_number, :concluded, :valid_from, :applies_to, :pay, :protection_variant, :assurance, :assurance_component, :family_lock, :note, :company_id, :user_id)
    end
end
