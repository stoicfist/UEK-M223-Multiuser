class Document < ApplicationRecord
  belongs_to :user
  belongs_to :template
  validates :title, presence: true
end
