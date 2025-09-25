class User < ApplicationRecord
  extend ActiveRecord::Enum

  # Zulässige Rollen
  ROLES = %w[user moderator admin].freeze

  has_secure_password

  # E-Mail vereinheitlichen
  normalizes :email, with: ->(e) { e.strip.downcase } if respond_to?(:normalizes)
  before_validation { self.email = email.to_s.strip.downcase } unless respond_to?(:normalizes)

  # Default-Rolle setzen (falls du die Migration mit Default noch nicht hast)
  before_validation { self.role = "user" if role.blank? }

  # Username
  validates :username, length: { maximum: 50 }, allow_blank: true

  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 12 }, if: -> { password.present? }

  # Rolle nur aus erlaubter Liste
  validates :role, inclusion: { in: ROLES }, allow_blank: true

  has_many :latex_templates, dependent: :destroy
  has_many :documents, dependent: :destroy

  enum :role, { user: "user", moderator: "moderator", admin: "admin" }, prefix: true

  # Fallback, falls alte Helper genutzt werden:
  def admin?      = role_admin?
  def moderator?  = role_moderator?
  def user?       = role_user?


  # --- E-Mail-Änderung ---
  def start_email_change!(new_email)
    new_email = new_email.to_s.strip.downcase
    raise ArgumentError, "Neue E-Mail erforderlich" if new_email.blank?
    raise ArgumentError, "E-Mail unverändert" if new_email == email

    token = SecureRandom.urlsafe_base64(32)

    transaction do
      update!(pending_email: new_email,
              pending_email_token: token,
              pending_email_token_sent_at: Time.current)

      # Mail versenden (in DEV reicht Logausgabe; siehe Mailer unten)
      ::UserMailer.email_change_confirmation(self).deliver_later
      Rails.logger.debug "confirmation_link=#{Rails.application.routes.url_helpers.confirm_email_change_url(token:, host: Rails.application.config.action_mailer.default_url_options[:host])}"
    end

    true
  end

  def confirm_pending_email!(token)
    raise ArgumentError, "Token fehlt" if token.blank?
    return false unless pending_email_token.present? && ActiveSupport::SecurityUtils.secure_compare(pending_email_token, token)

    # Optional: Ablaufzeit prüfen (z. B. 24h)
    if pending_email_token_sent_at.present? && pending_email_token_sent_at < 24.hours.ago
      errors.add(:base, "Bestätigungslink abgelaufen")
      return false
    end

    transaction do
      self.email = pending_email
      self.pending_email = nil
      self.pending_email_token = nil
      self.pending_email_token_sent_at = nil
      save!
    end
  end
end
