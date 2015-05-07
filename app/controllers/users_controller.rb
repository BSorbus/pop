class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :finish_signup]

  def index
    # authorize! :read, @user
    @users = User.all
  end

  # GET /users/:id.:format
  def show
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

  # GET /users/:id/edit
  #def edit
  #  # authorize! :update, @user
  #end

  
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
end
