FactoryBot.define do
  factory :document do
    association :user
    association :template
    title { "My Document" }
    body { "LaTeX Inhalt" }
  end
end
