# app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_action :require_login, except: [ :new, :create, :confirm_email ]

  # Registrierung (bereits vorhanden)

  def new
    @user = User.new
    authorize @user
  end

  def create
    @user = User.new(user_params)
    authorize @user
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Willkommen!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # --- Profil ---
  def show      # GET /account
    @user = current_user
  end

  def edit      # GET /account/edit
    @user = current_user
  end

  def update    # PATCH /account
    @user = current_user
    if @user.update(profile_params)
      redirect_to account_path, notice: "Profil aktualisiert."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # --- Passwort ändern ---
  def edit_password   # GET /account/edit_password
  end

  def update_password  # PATCH /account/update_password
    user = current_user

    unless User.authenticate_by(email: user.email, password: params.dig(:user, :current_password).to_s)
      flash.now[:alert] = "Aktuelles Passwort ist falsch."
      return render :edit_password, status: :unprocessable_entity
    end

    if user.update(password_params)
      redirect_to account_path, notice: "Passwort geändert."
    else
      flash.now[:alert] = user.errors.full_messages.to_sentence
      render :edit_password, status: :unprocessable_entity
    end
  end

  # --- E-Mail ändern (Bestätigungslink) ---
  def email_change     # POST /account/email_change
    new_email = params.require(:user).permit(:pending_email)[:pending_email]

    begin
      current_user.start_email_change!(new_email) # Methode im User-Model (siehe unten)
      redirect_to account_path, notice: "Bestätigungslink wurde an #{new_email} gesendet."
    rescue ActiveRecord::RecordInvalid => e
      redirect_to edit_account_path, alert: e.record.errors.full_messages.to_sentence
    rescue ArgumentError => e
      redirect_to edit_account_path, alert: e.message
    end
  end

  # --- E-Mail bestätigen (aus Link) ---
  def confirm_email    # GET /email_change/confirm/:token
    token = params[:token].to_s
    user  = User.find_by(pending_email_token: token)

    if user&.confirm_pending_email!(token)
      redirect_to login_path, notice: "E-Mail-Adresse bestätigt. Bitte erneut einloggen."
    else
      redirect_to root_path, alert: "Bestätigung fehlgeschlagen."
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :username, :password, :password_confirmation)
  end

  # erlaubte Profil-Felder
  def profile_params
    params.require(:user).permit(:username)
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
