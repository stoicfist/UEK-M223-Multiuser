class TemplatesController < ApplicationController
  before_action :require_login, except: %i[index show]
  before_action :set_template,  only: %i[show edit update destroy clone_to_document]

  # GET /templates
  def index
    @templates = policy_scope(Template)
  end

  # GET /templates/1
  def show
    authorize @template
  end

  # GET /templates/new
  def new
    @template = Template.new
    authorize @template
  end

  # POST /templates
  def create
    @template = current_user.templates.new(template_params)
    authorize @template
    if @template.save
      redirect_to @template, notice: "Template erstellt."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /templates/1/edit
  def edit
    authorize @template
  end

  # PATCH/PUT /templates/1
  def update
    authorize @template
    if @template.update(template_params)
      redirect_to @template, notice: "Template aktualisiert.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /templates/1
  def destroy
    authorize @template
    @template.destroy!
    redirect_to templates_path, notice: "Template gelöscht.", status: :see_other
  end

  # POST /templates/:id/clone_to_document
  def clone_to_document
    authorize @template, :show? # oder eigene Policy-Methode, falls nötig
    doc = current_user.documents.create!(
      template: @template,
      title:    @template.title,
      body:     @template.body
    )
    redirect_to edit_document_path(doc), notice: "Gekloned – jetzt anpassen."
  end

  private

  def require_login
    redirect_to new_session_path, alert: "Bitte melde dich an." unless current_user
  end

  def set_template
    @template = Template.find(params[:id])
  end

  def template_params
    params.require(:template).permit(:title, :visibility, :description, :body)
  end
end
