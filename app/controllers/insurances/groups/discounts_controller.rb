class Insurances::Groups::DiscountsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_back_if_dont_can_edit_discount, only: [:new, :edit, :destroy]


  # GET /insurances/:insurance_id/groups/:group_i/discounts/new
  def new
    @discount = Discount.new
    @group ||= load_group
    @insurance = load_insurance
    @discount.group = @group

    respond_to do |format|
      format.html
    end
  end

  # GET /insurances/:insurance_id/groups/:group_i/discounts/1/edit
  def edit
    @insurance = load_insurance
    @group ||= load_group # "||=" a nie "=" ponieważ ładuję w czasie "redirect_back_if_dont_can_edit"
    @discount = load_discount

    respond_to do |format|
      format.html
    end
  end

  # POST /insurances/:insurance_id/groups/:group_i/discounts
  # POST /insurances/:insurance_id/groups/:group_i/discounts.json
  def create
    @insurance = load_insurance
    @group = load_group
    @discount = Discount.new(discount_params)
    @discount.group = @group

    respond_to do |format|
      if @discount.save
        format.html { redirect_to insurance_group_path(@insurance, @group), success: t('activerecord.messages.successfull.created', data: @discount.fullname) }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @discount.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /insurances/:insurance_id/groups/:group_i/discounts/1
  # PATCH/PUT /insurances/:insurance_id/groups/:group_i/discounts/1.json
  def update
    @insurance = load_insurance
    @group = load_group
    @discount = load_discount

   respond_to do |format|
      if @discount.update(discount_params)
        format.html { redirect_to insurance_group_path(@insurance, @group), success: t('activerecord.messages.successfull.updated', data: @discount.fullname) }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @discount.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /discounts/1
  # DELETE /discounts/1.json
  def destroy
    @insurance = load_insurance
    @group ||= load_group # "||=" a nie "=" ponieważ ładuję w czasie "redirect_back_if_dont_can_edit"
    @discount = load_discount

    if @discount.destroy
      redirect_to insurance_group_path(@insurance, @group), success: t('activerecord.messages.successfull.destroyed', data: @discount.fullname)
    else 
      redirect_to insurance_group_path(@insurance, @group), error: t('activerecord.messages.error.destroyed', data: @discount.fullname)
    end      
  end

  private
    def load_discount
      Discount.find(params[:id])
    end

    def load_group
      Group.find(params[:group_id])
    end

    def load_insurance
      Insurance.find(params[:insurance_id])
    end


    def redirect_back_if_dont_can_edit_discount
      @group ||= load_group
      redirect_to :back, alert: "Grupa użyta w zablokowanej Rotacji!" if @group.group_used_in_locked_rotation
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def discount_params
      params.require(:discount).permit(:category, :description, :discount_increase, :group_id)
    end
end
