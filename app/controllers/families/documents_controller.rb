class Families::DocumentsController < DocumentsController
  before_action :set_documentable

  private

    def set_documentable
      @documentable = Family.find(params[:family_id])
    end

end