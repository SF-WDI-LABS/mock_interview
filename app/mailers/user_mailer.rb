class UserMailer < ApplicationMailer

  def welcome(user)
  	@user = user
    mail to: @user.email, subject: "Thanks for signing up!"
  end

  def reset_password(user)
  	@user = user
  	mail to: @user.email, subject: "Password reset"
  end

end