class ApplicationController < ActionController::Base
  include Pundit::Authorization

  helper_method :current_user, :logged_in?

  # ---- Auth-Helpers ----
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    return if logged_in?
    redirect_to new_session_path, alert: "Bitte melde dich an."
  end

  # Bei allen mutierenden Aktionen sicherstellen:
  after_action :verify_policy_scoped, if: -> { action_name == "index" }, unless: :pundit_skip?

  # ---- Pundit: Unauthorisierte Zugriffe abfangen ----
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def pundit_skip?
    %w[sessions passwords].include?(controller_name) # ergänze bei Bedarf
  end

  def user_not_authorized
    redirect_back fallback_location: root_path,
                  alert: "Zugriff nicht erlaubt."
  end
end
