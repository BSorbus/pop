class Companies::CompanyHistoriesController < ApplicationController
  before_action :authenticate_user!

  # GET /company_histories
  # GET /company_histories.json
  def index
    @company = load_company
    @company_histories = @company.company_histories

    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /company_histories/1
  # GET /company_histories/1.json
  def show
    @company = load_company
    @company_history = load_company_history

    respond_to do |format|
      format.html
      format.json
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def load_company_history
      CompanyHistory.find(params[:id])
    end

    def load_company
      Company.find(params[:company_id])
    end

end
