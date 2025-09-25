class Document < ApplicationRecord
  belongs_to :user
  belongs_to :latex_template, class_name: "LatexTemplate", foreign_key: "template_id"
  has_one_attached :image # optionales Bild für includegraphics  

  validates :title, presence: true
   # erzeugt compiled_body aus Template + params (+ Bildpfad)
  
  def render_from_latex_template!
    liquid_template = Liquid::Template.parse(latex_template.body)
    ctx = (self.params || {}).deep_dup
    ctx["date"]  ||= Time.zone.today.strftime("%d.%m.%Y")
    ctx["title"] ||= title
    ctx["image_path"] = image.attached? ? "images/#{image.filename}" : nil
    self.compiled_body = liquid_template.render(ctx.stringify_keys, strict_variables: false)
  end
end
