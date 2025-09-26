class Document < ApplicationRecord
  belongs_to :user
  belongs_to :latex_template, class_name: "LatexTemplate", foreign_key: "template_id"
  has_one_attached :image # optionales Bild für includegraphics  
  has_paper_trail

  validates :title, presence: true
   # erzeugt compiled_body aus Template + params (+ Bildpfad)
  
  validate :image_must_be_image_type, if: -> { image.attached? }
  validate :image_size_under_5mb,     if: -> { image.attached? }
  
  def render_from_latex_template!
    liquid_template = Liquid::Template.parse(latex_template.body)
    ctx = (self.params || {}).deep_dup
    ctx["date"]  ||= Time.zone.today.strftime("%d.%m.%Y")
    ctx["title"] ||= title
    ctx["image_path"] = image.attached? ? "images/#{image.filename}" : nil
    self.compiled_body = liquid_template.render(ctx.stringify_keys, strict_variables: false)
  end
  
  private

  def image_must_be_image_type
    allowed = %w[image/png image/jpeg image/webp image/gif]
    errors.add(:image, "muss PNG, JPG, WEBP oder GIF sein") unless image.content_type.in?(allowed)
  end

  def image_size_under_5mb
    errors.add(:image, "darf maximal 5 MB groß sein") if image.blob.byte_size > 5.megabytes
  end
end
