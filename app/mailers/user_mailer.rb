class UserMailer < ApplicationMailer
  # Schickt den Bestätigungslink an die neue (pending) E-Mail
  def email_change_confirmation(user)
    @user = user
    mail to: @user.pending_email, subject: "E-Mail-Adresse bestätigen"
  end
end
