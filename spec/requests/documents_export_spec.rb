require "rails_helper"
require "zip"  # nutzt rubyzip zum Lesen der Antwort

RSpec.describe "Documents ZIP export", type: :request do
  let(:owner)     { create(:user) }
  let(:other)     { create(:user) }
  let(:document)  { create(:document, user: owner, body: "Hello LaTeX") }

  def login_as(user, password: "longenough123")
    post sessions_path, params: { email: user.email, password: password }
    follow_redirect! if response.redirect?
  end

  it "requires login" do
    get export_zip_document_path(document)
    expect(response).to redirect_to(new_session_path)
  end

  it "blocks access to foreign documents" do
    login_as(other)
    get export_zip_document_path(document)
    expect(response).to redirect_to(root_path)
  end

  it "returns a valid zip containing main.tex with the document body" do
    login_as(owner)

    get export_zip_document_path(document)
    # Basis-Header
    expect(response).to have_http_status(:ok)
    expect(response.media_type).to eq("application/zip")
    expect(response.headers["Content-Disposition"]).to include(".zip")

    # ZIP-Inhalt prüfen
    zip_buffer = StringIO.new(response.body)
    filenames  = []
    main_tex   = nil

    Zip::File.open_buffer(zip_buffer) do |zip|
      zip.each do |entry|
        filenames << entry.name
        main_tex = entry.get_input_stream.read if entry.name == "main.tex"
      end
    end

    expect(filenames).to include("main.tex")
    expect(main_tex).to include("Hello LaTeX")
  end
end
