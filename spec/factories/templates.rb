FactoryBot.define do
  factory :template do
    association :user
    title { "Example Template" }
    visibility { "public" }
    description { "Kurzbeschreibung" }
    body { "\\documentclass{article}\n\\begin{document}\nHallo\n\\end{document}" }
  end
end