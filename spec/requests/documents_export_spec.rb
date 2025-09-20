require "rails_helper"
require "zip"

RSpec.describe "Documents ZIP export", type: :request do
  let(:owner)    { create(:user) }
  let(:other)    { create(:user) }
  let(:template) { create(:template, user: owner) }
  let(:document) { create(:document, user: owner, template: template, body: "Hello\n\\end{document}") }

  it "requires login" do
    get export_zip_document_path(document)
    expect(response).to redirect_to(new_session_path)
  end

  it "blocks access to foreign documents" do
    get export_zip_document_path(document),
        headers: { "rack.session" => { user_id: other.id } }
    expect(response).to have_http_status(:forbidden).or redirect_to(root_path)
  end

  it "returns a valid zip containing main.tex with the document body" do
    get export_zip_document_path(document),
        headers: { "rack.session" => { user_id: owner.id } }
    expect(response).to have_http_status(:ok)
    expect(response.media_type).to eq("application/zip")
  expect(response.headers["Content-Disposition"]).to include(".zip")

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
    expect(main_tex).to include("Hallo")
  end
end
