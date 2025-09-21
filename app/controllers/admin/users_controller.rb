  def index
    @users = policy_scope(User)
    authorize User
  end

  def edit
    @user = find_user
    authorize @user
  end

  def update
    @user = find_user
    authorize @user
    if @user.update(user_params_for_update)
      redirect_to admin_users_path, notice: t(".updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def update_role
    @user = find_user
    authorize @user, :update_role?
    if @user.update(role_params)
      redirect_to admin_users_path, notice: t(".role_updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def find_user = User.find(params[:id])

  # WICHTIG: Role Escalation verhindern
  def user_params_for_update
    params.require(:user).permit(:name, :email) # keine :role hier!
  end

  def role_params
    # Nur auf explizitem, authorisierten Endpunkt erlauben:
    params.require(:user).permit(:role)
  end
end