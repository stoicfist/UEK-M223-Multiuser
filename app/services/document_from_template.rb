class DocumentFromTemplate
  def initialize(user:, latex_template:, attrs:, image: nil)
    @user           = user
    @latex_template = latex_template
    @attrs          = attrs
    @image          = image
  end

  def call
    doc = Document.new(
      user: @user,
      latex_template: @latex_template,                   
      title: @attrs[:title].presence || @latex_template.title,
      params: {
        first_name: @attrs[:first_name],
        last_name:  @attrs[:last_name],
        date:       @attrs[:date]
      }.compact
    )
    doc.image.attach(@image) if @image.present?
    doc.render_from_latex_template!
    doc.save!
    doc
  end
end
