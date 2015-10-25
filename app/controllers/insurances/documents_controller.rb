class Insurances::DocumentsController < DocumentsController
  before_action :set_documentable

  private

    def set_documentable
      @documentable = Insurance.find(params[:insurance_id])
    end

end