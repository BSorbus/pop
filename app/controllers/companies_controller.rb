class CompaniesController < ApplicationController
  before_action :authenticate_user!


  # GET /companies
  # GET /companies.json
  def index
    authorize(Company)
    #@companies = policy_scope(Company)
    respond_to do |format|
      format.html
    end   
  end

  # POST /companies
  def datatables_index
    data_scope = current_user.admin? ? -1 : current_user.id
    respond_to do |format|
      format.json{ render json: CompanyDatatable.new(view_context, { only_for_current_user_id: data_scope }) }
    end
  end

  # GET /companies/1
  # GET /companies/1.json
  def show
    @company = load_company

    authorize @company

    respond_to do |format|
      format.html
      format.json
    end 
  end

  # GET /companies/new
  def new
    @company = Company.new
    @company.user = current_user

    authorize @company

    respond_to do |format|
      format.html
    end
  end

  # GET /companies/1/edit
  def edit
    @company = load_company

    authorize @company

    respond_to do |format|
      format.html
    end
  end

  # POST /companies
  # POST /companies.json
  def create
    @company = Company.new(company_params)
    @company.user = current_user

    authorize @company

    respond_to do |format|
      if @company.save
        format.html { redirect_to @company, success: t('activerecord.messages.successfull.created', data: @company.short) }
        format.json { render :show, status: :created, location: @company }
      else
        format.html { render :new }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /companies/1
  # PATCH/PUT /companies/1.json
  def update
    @company = load_company
        
    authorize @company

    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to @company, success: t('activerecord.messages.successfull.updated', data: @company.short) }
        format.json { render :show, status: :ok, location: @company }
      else
        format.html { render :edit }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def destroy
    @company = load_company    

    authorize @company

    if @company.destroy
      redirect_to companies_url, success: t('activerecord.messages.successfull.destroyed', data: @company.short)
    else 
      flash[:alert] = t('activerecord.messages.error.destroyed', data: @company.short)
      render :show
    end      
  end

  private

    def load_company
      if current_user.admin?
        Company.find(params[:id])
      else
        Company.by_user(current_user.id).find(params[:id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def company_params
      params.require(:company).permit(:short, :name, :address_city, :address_street, :address_house, :address_number, :address_postal_code, :phone, :email, :nip, :regon, :pesel, :informal_group, :note, :user_id)
    end
end
