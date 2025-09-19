class User < ApplicationRecord
  has_secure_password

  # E-Mail vereinheitlichen
  normalizes :email, with: ->(e) { e.strip.downcase } if respond_to?(:normalizes)
  # Fallback, falls 'normalizes' nicht da ist:
  before_validation { self.email = email.to_s.strip.downcase } unless respond_to?(:normalizes)

  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 12 }, if: -> { password.present? }

  has_many :templates, dependent: :destroy
  has_many :documents, dependent: :destroy
end
