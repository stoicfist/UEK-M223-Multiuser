class Template < ApplicationRecord
  belongs_to :user
  has_many :documents, dependent: :nullify
  enum :visibility, { public: "public", private: "private" }, prefix: :vis
  validates :title, :visibility, presence: true
end
