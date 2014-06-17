class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

 #RLM - this was not expressly deleted on p.40, Ch.7 but
 #I think it was meant to be replaced by the user.new below.
 #However, when I commented the next 3 lines the signup form 
 #did not work. Looks like the def new is required in addition to def create
 def new
    @user = User.new
  end



  def edit
   # @user = User.find(params[:id]) RLM - removed per Ch.9, p.24.
  end  



  def update
   # @user = User.find(params[:id]) RLM - removed per Ch.9, p.24.
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end

  def create
    @user = User.new(user_params) 
    if @user.save
      sign_in @user      
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user    
    else
      render 'new'
    end
  end

    private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # Before filters

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end