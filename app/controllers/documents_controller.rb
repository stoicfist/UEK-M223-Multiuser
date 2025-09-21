class DocumentsController < ApplicationController
  before_action :require_login
  before_action :set_document, only: [ :show, :edit, :update, :destroy, :export_zip ]
  before_action :authorize_owner!, only: [ :show, :edit, :update, :destroy, :export_zip ]

  # GET /documents
  def index
    @documents = policy_scope(Document)
  end

  # GET /documents/1
  def show; end

  # GET /documents/new
  def new
    @document = Document.new
  end

  # GET /documents/1/edit
  def edit; end

  # POST /documents
  def create
    @document = current_user.documents.new(document_params)
    if @document.save
      redirect_to @document, notice: "Dokument erstellt."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /documents/1
  def update
    if @document.update(document_params)
      redirect_to @document, notice: "Dokument aktualisiert.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /documents/1
  def destroy
    @document.destroy!
    redirect_to documents_path, notice: "Dokument gelöscht.", status: :see_other
  end

  # Export to zip
  def export_zip
  require "zip"

  buffer = Zip::OutputStream.write_buffer do |zos|
    zos.put_next_entry("main.tex")
    zos.write @document.body.to_s
  end
  buffer.rewind

  send_data buffer.string,
            filename: "#{@document.title.parameterize}.zip",
            type: "application/zip",
            disposition: "attachment"
end


  private

  def set_document
    @document = Document.find(params[:id])
  end

  def authorize_owner!
    redirect_to root_path, alert: "Keine Berechtigung." unless @document.user == current_user
  end

  def document_params
    params.require(:document).permit(:title, :body, :template_id)
  end
end
