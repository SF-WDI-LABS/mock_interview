class PasswordResetsController < ApplicationController
  before_action :set_user, only: [:edit, :update]
  before_action :valid_user?, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

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
  end

  def update
    @user.update_attributes(user_params)
    session[:user_id] = @user.id
    flash[:notice] = "Your password has been reset."
    redirect_to user_path(@user)
  end

  private

  	def password_reset_params
  		params.require(:password_reset).permit(:email)
  	end

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def set_user
      @user = User.find_by_email(params[:email])
    end

    def valid_user?
      unless @user && @user.authenticated?(:reset, params[:id])
        redirect_to root_path and return
      end
    end

    def check_expiration
      if @user.password_reset_expired?
        flash[:error] = "Password reset has expired."
        redirect_to new_password_reset_path and return
      end
    end

end