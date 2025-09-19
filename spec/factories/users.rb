FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { "longenough123" } # ≥ 12 Zeichen
  end
end