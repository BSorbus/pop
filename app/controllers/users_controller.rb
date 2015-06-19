class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :destroy, :finish_signup]

  def index
    @users = User.all
    authorize current_user
  end

  # GET /users/:id.:format
  def show
    authorize @user
    respond_to do |format|
      format.html

      ##wlasnego buildera uruchamia
      #format.json { render json: @user }

      ##pobiera dane zdefiniowane w pliku show.json.builder
      format.json 

      ##lub idzie z definicji
      #format.json { render json: @user.as_json(only: [:id, :name, :email, :content]) }
      #format.json { render json: @user.as_json(only: [:id, :name, :email, :content], include: {identities: {only:[:id, :user_id, :provider, :uid, :content]}}) }
    end
  end

  # GET /events/pdf_invoice?invoice_date=2015,06,01
  def pdf_invoice
    invoice_date = (params[:invoice_date]).to_date    

    respond_to do |format|
      format.pdf do
        pdf = InvoicePdf.new(current_user, invoice_date, view_context)
        send_data pdf.render,
        filename: "invoice_#{invoice_date.strftime("%Y-%m-%d")}.pdf",
        type: "application/pdf",
        disposition: "inline"        
      end
    end 
  end


  def update
    #@user = User.find(params[:id])
    authorize @user
    if @user.update_attributes(secure_params)
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end


  def destroy
    user = User.find(params[:id])
    authorize user
    user.destroy
    redirect_to users_path, :notice => "User deleted."
  end
  
  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      #accessible = [ :name, :email ] # extend with your own params
      #accessible = [ :name, :email, :password, :password_confirmation ] # extend with your own params
      accessible << [ :password, :password_confirmation ] unless params[:user][:password].blank?
      params.require(:user).permit(accessible)
    end

    def secure_params
      params.require(:user).permit(:role)
    end
end
