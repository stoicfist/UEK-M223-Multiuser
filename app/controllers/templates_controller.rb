class TemplatesController < ApplicationController
  before_action :require_login, except: [:index, :show]
  before_action :set_template, only: [:show, :edit, :update, :destroy, :clone_to_document]
  before_action :authorize_owner!, only: [:edit, :update, :destroy]

  # GET /templates
  def index
    # Öffentlich + (eigene, wenn eingeloggt)
    @templates = Template.where(visibility: "public")
    @templates = @templates.or(Template.where(user: current_user)) if logged_in?
  end

  # GET /templates/1
  def show; end

  # GET /templates/new
  def new
    @template = Template.new
  end

  # GET /templates/1/edit
  def edit; end

  # POST /templates
  def create
    @template = current_user.templates.new(template_params)
    if @template.save
      redirect_to @template, notice: "Template erstellt."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /templates/1
  def update
    if @template.update(template_params)
      redirect_to @template, notice: "Template aktualisiert.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /templates/1
  def destroy
    @template.destroy!
    redirect_to templates_path, notice: "Template gelöscht.", status: :see_other
  end

  # POST /templates/:id/clone_to_document
  def clone_to_document
    doc = current_user.documents.create!(
      template: @template,
      title: @template.title,
      body:  @template.body
    )
    redirect_to edit_document_path(doc), notice: "Gekloned – jetzt anpassen."
  end

  private

  def set_template
    @template = Template.find(params[:id])
  end

  def authorize_owner!
    redirect_to root_path, alert: "Keine Berechtigung." unless @template.user == current_user
  end

  def template_params
    params.require(:template).permit(:title, :visibility, :description, :body)
  end
end
