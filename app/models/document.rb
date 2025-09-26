class Document < ApplicationRecord
  belongs_to :user
  belongs_to :latex_template, class_name: "LatexTemplate", foreign_key: "template_id"
  has_one_attached :image
  has_paper_trail

  validates :title, presence: true
  validate :image_must_be_image_type, if: -> { image.attached? }
  validate :image_size_under_5mb,     if: -> { image.attached? }

  def render_from_latex_template!
    liquid_template = Liquid::Template.parse(latex_template.body)
    ctx = (self.params || {}).deep_dup
    ctx["date"]       ||= Time.zone.today.strftime("%d.%m.%Y")
    ctx["title"]      ||= title
    ctx["image_path"]  = image.attached? ? "images/#{image.filename}" : nil
    self.compiled_body = liquid_template.render(ctx.stringify_keys, strict_variables: false)
  end

  private

  def image_must_be_image_type
    allowed_types = %w[image/png image/jpeg image/jpg image/webp image/gif]
    allowed_exts  = %w[.png .jpg .jpeg .webp .gif]
    ct  = image.blob&.content_type.to_s
    ext = File.extname(image.blob&.filename.to_s).downcase
    unless allowed_types.include?(ct) || allowed_exts.include?(ext)
      errors.add(:image, "muss PNG, JPG, WEBP oder GIF sein")
    end
  end

  def image_size_under_5mb
    size = image.blob&.byte_size.to_i
    errors.add(:image, "darf maximal 5 MB groß sein") if size > 5.megabytes
  end
end