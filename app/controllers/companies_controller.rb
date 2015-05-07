class CompaniesController < ApplicationController
  before_action :authenticate_user!


#  def update_cities
#    @cities = City.where("country_id = ?", params[:country_id])
#    respond_to do |format|
#      format.js
#    end
#  end

  def select_his
    #filter using id passed by ajax
    @selected_history = CompanyHistory.find_by(id: params[:send_id])
 
    render json: @selected_history
    #respond_to do |format|
    #  format.json { render json: @selected_history }
    #end

  end 

  # GET /companies
  # GET /companies.json
  def index
    respond_to do |format|
      format.html
    end   
  end

  # POST /companies
  def datatables_index
    respond_to do |format|
      format.json{ render json: CompanyDatatable.new(view_context, { only_for_current_user_id: current_user.id }) }
    end
  end

  # GET /companies/1
  # GET /companies/1.json
  def show
    @company = load_company

    respond_to do |format|
      format.html
      format.json
    end 
  end

  # GET /companies/new
  def new
    @company = Company.new
    @company.user = current_user

    respond_to do |format|
      format.html
    end
  end

  # GET /companies/1/edit
  def edit
    @company = load_company

    respond_to do |format|
      format.html
    end
  end

  # POST /companies
  # POST /companies.json
  def create
    @company = Company.new(company_params)
    @company.user = current_user

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

    if @company.destroy
      redirect_to companies_url, success: t('activerecord.messages.successfull.destroyed', data: @company.short)
    else 
      flash[:alert] = t('activerecord.messages.error.destroyed', data: @company.short)
      render :show
    end      
  end

  private

    def load_company
      Company.by_user(current_user.id).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def company_params
      params.require(:company).permit(:short, :name, :address_city, :address_street, :address_house, :address_number, :address_postal_code, :phone, :email, :nip, :regon, :pesel, :informal_group, :note, :user_id)
    end
end
