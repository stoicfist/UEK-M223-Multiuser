FactoryBot.define do
  factory :template do
    association :user
    title { "Example Template" }
    visibility { "public" }
    description { "Kurzbeschreibung" }
    body { "\\documentclass{article}\n\\begin{document}\nHallo\n\\end{document}" }

    trait :private do
      title { "My Template" }
      visibility { "private" }
      description { "desc" }
      body { "Body" }
    end
  end
end
