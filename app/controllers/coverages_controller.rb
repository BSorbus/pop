class CoveragesController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_back_if_dont_can_edit_coverage, only: [:new, :edit, :destroy]

  respond_to :html

  # POST /insurances
  def datatables_index_rotation
    respond_to do |format|
      format.json{ render json: RotationCoveragesDatatable.new(view_context, { only_for_rotation_id: params[:rotation_id] }) }
    end
  end

  # POST /insurances
  def datatables_index_group
    respond_to do |format|
      format.json{ render json: GroupCoveragesDatatable.new(view_context, { only_for_group_id: params[:group_id] }) }
    end
  end

  # POST /insurances
  def datatables_index_insured
    respond_to do |format|
      format.json{ render json: InsuredCoveragesDatatable.new(view_context, { only_for_insured_id: params[:insured_id] }) }
    end
  end

  # POST /insurances
  def datatables_index_payer
    respond_to do |format|
      format.json{ render json: PayerCoveragesDatatable.new(view_context, { only_for_payer_id: params[:payer_id] }) }
    end
  end

  def new
    @coverage = Coverage.new

    # oryginalnie było
    #respond_with(@coverage)

    @rotation ||= load_rotation
    @group ||= load_group
    
    @rotation ||= @group.insurance.rotations.last if (params[:rotation_id]).nil?

    @coverage.rotation = @rotation if @rotation.present?
    @coverage.group = @group if @group.present?

    respond_to do |format|
      format.html { render :new, locals: { back_url: params[:back_url]} }
    end    
  end

  def edit
    # oryginalnie było pusto

    @coverage ||= load_coverage
    @rotation ||= load_rotation

    respond_to do |format|
      format.html { render :edit, locals: { back_url: params[:back_url]} }
    end
  end

  def create
    # oryginalnie było
    #@coverage = Coverage.new(coverage_params)
    #@coverage.save
    #respond_with(@coverage)

    params[:back_url] = root_url if (params[:back_url]).blank? 
    @coverage = Coverage.new(coverage_params)

    respond_to do |format|
      if @coverage.save
        format.html { redirect_to params[:back_url], success: t('activerecord.messages.successfull.created', data: @coverage.fullname) }
      else
        format.html { render :new, locals: { back_url: params[:back_url]} }
      end
    end

  end

  #def update
  #  @coverage.update(coverage_params)
  #  respond_with(@coverage)
  #end
  def update
    params[:back_url] = root_url if (params[:back_url]).blank? 
    @coverage ||= load_coverage

    respond_to do |format|
      if @coverage.update(coverage_params)
        format.html { redirect_to params[:back_url], success: t('activerecord.messages.successfull.updated', data: @coverage.fullname) }
      else
        format.html { render :edit, locals: { back_url: params[:back_url]} }
      end
    end
  end

  def destroy
    #@coverage.destroy
    #respond_with(@coverage)

    @coverage ||= load_coverage

    respond_to do |format|
      if @coverage.destroy
        format.html { redirect_to :back, success: t('activerecord.messages.successfull.destroyed', data: @coverage.fullname) }
        format.js { }
      else
        format.html { redirect_to :back, error: t('activerecord.messages.error.destroyed', data: @coverage.fullname) }
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
    def load_coverage
      Coverage.find(params[:id])
    end

    def load_rotation
      Rotation.find(params[:rotation_id]) if !(params[:rotation_id]).nil?
    end

    def load_group
      Group.find(params[:group_id]) if !(params[:group_id]).nil?
    end

    def redirect_back_if_dont_can_edit_coverage
      if (params[:id]).nil?
        if (params[:rotation_id]).nil? 
          @group = load_group
          @rotation = @group.insurance.rotations.last 
        else 
          @rotation = load_rotation
        end
      else
        @coverage = load_coverage
        @rotation = @coverage.rotation
      end

      redirect_to :back, alert: "Polisa lub Rotacja jest zablokowana!" if (@rotation.rotation_lock? || @rotation.insurance.insurance_lock?) #   || == 'OR'
    end

    def coverage_params
      params.require(:coverage).permit(:rotation_id, :group_id, :insured_id, :payer_id, :note)
    end
end
