class LatexTemplate < ApplicationRecord
  self.table_name = "templates"
  belongs_to :user
  has_many :documents, dependent: :nullify

  enum :visibility, { public: "public", private: "private" }, prefix: :vis

  # Body muss vorhanden sein – setzen wir notfalls automatisch
  validates :title, :visibility, :body, presence: true
  validate :body_must_be_valid_liquid

  before_validation :neutralize_empty_liquid_if

  # Standard-A4-Template mit Liquid-Platzhaltern
  DEFAULT_BODY = <<~LATEX.freeze
  %%% LaTeXHub Default A4 Template  (Platzhalter: {{ first_name }}, {{ last_name }}, {{ date }})
    \\documentclass[a4paper,12pt]{article}
    \\usepackage[margin=2.5cm]{geometry}
    \\usepackage[T1]{fontenc}
    \\usepackage[utf8]{inputenc}
    \\usepackage[ngerman]{babel}
    \\usepackage{microtype}
    \\usepackage{hyperref}
    \\usepackage{xcolor}
    \\usepackage{graphicx} % Einbindung nur, wenn Bild vorhanden

    \\begin{document}
    \\begin{flushright}
    {{ first_name }} {{ last_name }}\\\\
    {{ date }}
    \\end{flushright}

    \\section*{Titel: {{ title }}}
    Dies ist ein Beispieltext. Ersetze ihn in deinem Dokument.

    {% if image_path %}
    \\bigskip
    \\begin{center}
    \\includegraphics[width=\\textwidth]{ {{ image_path }} }
    \\end{center}
    {% endif %}

    \\end{document}
  LATEX

  # Falls beim Anlegen/Updaten kein Body mitkommt, Standard setzen
  before_validation :ensure_default_body

  private

  def ensure_default_body
    self.body = DEFAULT_BODY if body.blank?
  end

  def neutralize_empty_liquid_if
    self.body = body.to_s.gsub(/{%\s*if\s*%}/, '{% raw %}{% if %}{% endraw %}')
  end

  def body_must_be_valid_liquid
    Liquid::Template.parse(body.to_s)
  rescue Liquid::SyntaxError => e
    errors.add(:body, "enthält ungültige Liquid-Syntax: #{e.message}")
  end
end