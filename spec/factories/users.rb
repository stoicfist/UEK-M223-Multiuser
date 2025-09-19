FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "x" * 12 }
    password_digest { BCrypt::Password.create(password) }
    username { "Max" }
  end
end
