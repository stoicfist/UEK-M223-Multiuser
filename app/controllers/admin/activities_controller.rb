class Admin::ActivitiesController < ApplicationController
  before_action :require_login

  def index
    authorize :activity, :index?

    @users = User.order(:email) # für das Dropdown

    versions = policy_scope(PaperTrail::Version)
                  .includes(:item)
                  .order(created_at: :desc)

    # Filter
    versions = versions.where(item_type: params[:type]) if params[:type].present?
    versions = versions.where(event:     params[:event]) if params[:event].present?

    if params[:user_id].present?
      # PaperTrail speichert whodunnit i.d.R. als String der User-ID
      versions = versions.where(whodunnit: params[:user_id].to_s)
    end

    if params[:from].present? && params[:to].present?
      versions = versions.where(created_at: params[:from]..params[:to])
    end

    @versions        = versions.limit(100) # oder Kaminari .page(params[:page]).per(50)
    @activity_by_day = versions.group_by_day(:created_at, time_zone: Time.zone).count
  end
end
