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
  end

  private

  	def password_reset_params
  		params.require(:password_reset).permit(:email)
  	end

end