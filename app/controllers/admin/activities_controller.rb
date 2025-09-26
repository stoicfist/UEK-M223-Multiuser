class Admin::ActivitiesController < ApplicationController
  before_action :require_login

  EVENT_LABELS = {
    "create"  => "Erstellt",
    "update"  => "Aktualisiert",
    "destroy" => "Gelöscht"
  }.freeze

  def index
    authorize :activity, :index?

    @users = policy_scope(User).select(:id, :email, :username).order(:email)

    versions = policy_scope(PaperTrail::Version)
                .includes(:item)
                .order(created_at: :desc)

    # -------- Filter --------
    if params[:item_type].present? && params[:item_type] != "all"
      versions = versions.where(item_type: params[:item_type])
    end

    if params[:event].present? && params[:event] != "all"
      versions = versions.where(event: params[:event])
    end

    if params[:user_id].present?
      versions = versions.where(whodunnit: params[:user_id].to_s)
    end

    if params[:from].present? || params[:to].present?
      from = params[:from].presence && Time.zone.parse(params[:from]).beginning_of_day
      to   = params[:to].presence   && Time.zone.parse(params[:to]).end_of_day
      versions = versions.where(created_at: (from || Time.at(0))..(to || Time.zone.now))
    end

    # -------- Charts --------
    # Falls du groupdate hast:
    # @activity_by_day = versions.group_by_day(:created_at, time_zone: Time.zone.name).count
    # Fallback ohne groupdate:
    @activity_by_day = versions.group(Arel.sql("DATE(created_at)")).count.transform_keys(&:to_s)


    @activity_by_event = versions.group(:event).count
                                .transform_keys { |k| EVENT_LABELS[k] || k }

    @activity_by_model = versions.group(:item_type).count

    @activity_by_user  = versions.group(:whodunnit).count.transform_keys do |uid|
      User.find_by(id: uid)&.email || "Unbekannt (#{uid || "—"})"
    end

    # Tabelle
    @versions = defined?(Kaminari) ? versions.page(params[:page]).per(50) : versions.limit(100)
  end

  def show
    authorize :activity, :show?  # falls du eine Pundit-Policy hast; sonst Zeile entfernen
    @version = policy_scope(PaperTrail::Version).find(params[:id])
  end
end
