class LatexTemplatesController < ApplicationController
  before_action :require_login, except: %i[index show]
  before_action :set_latex_template, only: %i[show edit update destroy clone_to_document new_document create_document]

  def index
    @latex_templates = policy_scope(LatexTemplate) # Pundit
  end

  def show
    authorize @latex_template
  end

  def new
    @latex_template = LatexTemplate.new
    authorize @latex_template
  end

  def create
    @latex_template = current_user.latex_templates.new(latex_template_params)
    authorize @latex_template
    if @latex_template.save
      redirect_to @latex_template, notice: "Latex Template erstellt."
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
    authorize @latex_template
  end

  def update
    authorize @latex_template
    if @latex_template.update(latex_template_params)
      redirect_to @latex_template, notice: "Latex Template aktualisiert.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    authorize @latex_template
    @latex_template.destroy!
    redirect_to latex_templates_path, notice: "Latex Template gelöscht.", status: :see_other
  end

  # Alt-Flow kompatibel lassen: leitet auf parametrierten Flow
  def clone_to_document
    authorize @latex_template, :show?
    redirect_to new_document_latex_template_path(@latex_template), notice: "Bitte Parameter ausfüllen."
  end

  def new_document
    authorize @latex_template
    @document = Document.new
    @prefill = { title: "", date: "", first_name: "", last_name: "" } unless defined?(@prefill)
  end

  def create_document
    authorize @latex_template
    doc = DocumentFromTemplate.new(
      user: current_user,
      latex_template: @latex_template,
      attrs: document_params,
      image: params.dig(:document, :image)
    ).call
    redirect_to doc, notice: "Dokument erstellt."
  rescue ActiveRecord::RecordInvalid => e
    flash.now[:alert] = e.record.errors.full_messages.to_sentence
    render :new_document, status: :unprocessable_content
  end

  private

  def require_login
    redirect_to new_session_path, alert: "Bitte melde dich an." unless current_user
  end

  def set_latex_template
    @latex_template = LatexTemplate.find(params[:id])
  end

  def latex_template_params
    params.require(:latex_template).permit(:title, :visibility, :description, :body)
  end

  def document_params
    params.require(:document).permit(:title, :first_name, :last_name, :date)
  end
end
