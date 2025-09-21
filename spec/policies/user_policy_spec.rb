# spec/policies/user_policy_spec.rb
require "rails_helper"

RSpec.describe UserPolicy do
  subject { described_class }

  let(:admin)     { build(:user, role: "admin") }
  let(:moderator) { build(:user, role: "moderator") }
  let(:user)      { build(:user, role: "user") }
  let(:other)     { build(:user, role: "user") }

  permissions :index? do
    it { expect(subject).to permit(admin, User) }
    it { expect(subject).to permit(moderator, User) }
    it { expect(subject).not_to permit(user, User) }
  end

  permissions :update? do
    it { expect(subject).to permit(admin, other) }
    it { expect(subject).to permit(user, user) }
    it { expect(subject).not_to permit(user, other) }
  end

  permissions :update_role? do
    it { expect(subject).to permit(admin, other) }
    it { expect(subject).not_to permit(moderator, other) }
    it { expect(subject).not_to permit(user, other) }
  end
end
