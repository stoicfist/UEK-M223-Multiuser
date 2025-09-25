class SessionsController < ApplicationController
  def new; end
  
  def create
    user = User.authenticate_by(email: params[:email], password: params[:password])
    if user
      session[:user_id] = user.id
      redirect_to root_path, notice: "Eingeloggt."
    else
      flash.now[:alert] = "Login fehlgeschlagen."
      render :new, status: :unprocessable_entity
    end
  end
  def destroy
    reset_session
    redirect_to root_path, notice: "Abgemeldet."
  end
end


