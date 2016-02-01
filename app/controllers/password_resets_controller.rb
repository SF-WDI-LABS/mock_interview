class PasswordResetsController < ApplicationController

  def new
  end

  def create
  	@user = User.find_by_email(password_reset_params[:email])
    if @user
      @user.create_reset_digest
      UserMailer.reset_password(@user).deliver_now
    end
    flash[:notice] = "Email sent with password reset instructions."
    redirect_to root_path
  end

  def edit
    @user = User.find_by_email(params[:email])
    unless @user && @user.authenticated?(:reset, params[:id])
      redirect_to root_path
    end
  end

  def update
    @user = User.find_by_email(user_params[:email])
    unless @user && @user.authenticated?(:reset, params[:id])
      redirect_to root_path
    end
    @user.update_attributes(password: user_params[:password], password_confirmation: user_params[:password_confirmation])
    session[:user_id] = @user.id
    flash[:notice] = "Your password has been reset."
    redirect_to user_path(@user)
  end

  private

  	def password_reset_params
  		params.require(:password_reset).permit(:email)
  	end

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end

end