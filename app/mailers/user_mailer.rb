class UserMailer < ApplicationMailer
  def welcome
    @user = params[:user]

    mail(to: @user.email, subject: "Welcome to Clockify!")
  end
end
