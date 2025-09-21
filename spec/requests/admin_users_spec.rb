require "rails_helper"


RSpec.describe "Admin::Users", type: :request do
  let(:admin) { create(:user, role: "admin") }
  let(:user)  { create(:user, role: "user") }

  it "verhindert Role Escalation via update" do
    sign_in user
    patch admin_user_path(user), params: { user: { role: "admin" } }, headers: auth_headers
    expect(user.reload.role).to eq("user")
  end

  it "erlaubt Admins die Rolle zu ändern" do
    sign_in admin
    patch update_role_admin_user_path(user), params: { user: { role: "moderator" } }
    expect(user.reload.role).to eq("moderator")
  end
end
