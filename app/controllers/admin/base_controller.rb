class Admin::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin_area!

  private

  def authorize_admin_area!
    # Zugriff wird über Policy geregelt – hier Dummy-Record nutzen:
    authorize(User, :index?)
  end
end
