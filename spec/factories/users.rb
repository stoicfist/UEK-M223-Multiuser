FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "SuperSicher123!" }  # >= 12 Zeichen
    password_confirmation { password }
    username { "Max" }
    role { "user" }
  end
end
