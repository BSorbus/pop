class FamilyCoveragesController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_back_if_dont_can_edit_coverage, only: [:new, :edit, :destroy]

  respond_to :html

  # POST /insurances
  def datatables_index_rotation
    respond_to do |format|
      format.json{ render json: FamilyRotationFamilyCoveragesDatatable.new(view_context, { only_for_family_rotation_id: params[:family_rotation_id] }) }
    end
  end

  # POST /insurances
  def datatables_index_insured
    respond_to do |format|
      format.json{ render json: InsuredFamilyCoveragesDatatable.new(view_context, { only_for_insured_id: params[:insured_id] }) }
    end
  end

  # POST /insurances
  def datatables_index_payer
    respond_to do |format|
      format.json{ render json: PayerFamilyCoveragesDatatable.new(view_context, { only_for_payer_id: params[:payer_id] }) }
    end
  end

  # GET /family_coverages/new
  def new
    @family_coverage = FamilyCoverage.new

    @family_rotation ||= load_family_rotation
    
    @family_coverage.family_rotation = @family_rotation if @family_rotation.present?

    respond_to do |format|
      format.html { render :new, locals: { back_url: params[:back_url]} }
    end    
  end

  # GET /family_coverages/1/edit
  def edit
    # oryginalnie było pusto

    @family_coverage ||= load_family_coverage
    @family_rotation ||= load_family_rotation

    respond_to do |format|
      format.html { render :edit, locals: { back_url: params[:back_url]} }
    end
  end

  # POST /family_coverages
  # POST /family_coverages.json
  def create
    params[:back_url] = root_url if (params[:back_url]).blank? 
    @family_coverage = FamilyCoverage.new(family_coverage_params)

    respond_to do |format|
      if @family_coverage.save
        format.html { redirect_to params[:back_url], success: t('activerecord.messages.successfull.created', data: @family_coverage.fullname) }
      else
        format.html { render :new, locals: { back_url: params[:back_url]} }
      end
    end

  end

  # PATCH/PUT /family_coverages/1
  # PATCH/PUT /family_coverages/1.json
  def update
    params[:back_url] = root_url if (params[:back_url]).blank? 
    @family_coverage ||= load_family_coverage

    respond_to do |format|
      if @family_coverage.update(family_coverage_params)
        format.html { redirect_to params[:back_url], success: t('activerecord.messages.successfull.updated', data: @family_coverage.fullname) }
      else
        format.html { render :edit, locals: { back_url: params[:back_url]} }
      end
    end
  end

  # DELETE /family_coverages/1
  # DELETE /family_coverages/1.json
  def destroy
    #@coverage.destroy
    #respond_with(@coverage)

    @family_coverage ||= load_family_coverage

    respond_to do |format|
      if @family_coverage.destroy
        format.html { redirect_to :back, success: t('activerecord.messages.successfull.destroyed', data: @family_coverage.fullname) }
        format.js { }
      else
        format.html { redirect_to :back, error: t('activerecord.messages.error.destroyed', data: @family_coverage.fullname) }
        format.js 
        #format.js { flash.now[:notice] = t('activerecord.messages.error.destroyed', data: @coverage.fullname) }
      end
    end
  end

  def search_for_name
    @resources = Individual.select([:id, :name]).
                          where("name like :q", q: "%#{params[:q]}%").
                          order('name').page(params[:page]).per(params[:per]) # this is why we need kaminari. of course you could also use limit().offset() instead
   
    # also add the total count to enable infinite scrolling
    resources_count = Individual.select([:id, :name]).
                          where("name like :q", q: "%#{params[:q]}%").count
   
    respond_to do |format|
      format.json { render json: {total: resources_count, resources: @resources.map { |e| {id: e.id, text: "#{e.name} (#{e.pesel})"} }} }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def load_family_coverage
      FamilyCoverage.find(params[:id])
    end

    def load_family_rotation
      FamilyRotation.find(params[:family_rotation_id]) if !(params[:family_rotation_id]).nil?
    end

    def redirect_back_if_dont_can_edit_coverage
      if (params[:id]).nil?
        @family_rotation = load_family_rotation
      else
        @family_coverage = load_family_coverage
        @family_rotation = @family_coverage.family_rotation
      end

      redirect_to :back, alert: "Polisa lub Rotacja jest zablokowana!" if (@family_rotation.rotation_lock? || @family_rotation.family.family_lock?) #   || == 'OR'
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def family_coverage_params
      params.require(:family_coverage).permit(:family_rotation_id, :insured_id, :payer_id, :note)
    end
end
