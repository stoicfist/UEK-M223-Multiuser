module Admin
  class UsersController < ApplicationController
    before_action :require_login
    before_action :set_user, only: %i[ edit update ]

    def index
      authorize User # prüft UserPolicy#index?
      @users = policy_scope(User).order(created_at: :desc)
    end

    def edit
      authorize @user
    end

    def update
      authorize @user

      # Basis-Felder, die Admin ändern darf
      permitted = params.require(:user).permit(:email, :username, :password, :password_confirmation)

      # Rolle nur, wenn Admin dazu berechtigt
      if policy(@user).update_role?
        permitted[:role] = params[:user][:role]
      end

      if @user.update(permitted)
        redirect_to admin_users_path, notice: "Benutzer aktualisiert."
      else
        flash.now[:alert] = @user.errors.full_messages.to_sentence
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def set_user
      @user = User.find(params[:id])
    end
  end
end
