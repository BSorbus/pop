class Companies::DocumentsController < DocumentsController
  before_action :set_documentable

  private

    def set_documentable
      @documentable = Company.find(params[:company_id])
    end

end