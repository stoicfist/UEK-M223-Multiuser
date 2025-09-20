require "rails_helper"

RSpec.describe UserPolicy do
  subject(:policy) { described_class }

  let(:admin)  { build(:user, role: "admin") }
  let(:member) { build(:user, role: "user") }
  let(:other)  { build(:user, role: "user") }

  permissions :index? do
    it "allows admin to see index" do
      expect(policy).to permit(admin, User)
    end

    it "denies non-admin index" do
      expect(policy).not_to permit(member, User)
    end
  end

  permissions :update? do
    it "allows user to update self" do
      expect(policy).to permit(member, member)
    end

    it "denies user to update others" do
      expect(policy).not_to permit(member, other)
    end

    it "allows admin to update any" do
      expect(policy).to permit(admin, other)
    end
  end
end
