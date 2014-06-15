class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

 #RLM - this was not expressly deleted on p.40, Ch.7 but
 #I think it was meant to be replaced by the user.new below.
 #However, when I commented the next 3 lines the signup form 
 #did not work.
 def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)    # Not the final implementation!
    if @user.save
      # Handle a successful save.
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

end