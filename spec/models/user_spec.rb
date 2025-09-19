# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it "is valid with a unique email and a password of 12+ characters" do
      user = build(:user, password: "longenough123")
      expect(user).to be_valid
    end

    it "is invalid with a duplicate email" do
      create(:user, email: "test@example.com", password: "longenough123")
      duplicate_user = build(:user, email: "test@example.com", password: "anotherlong123")
      expect(duplicate_user).not_to be_valid
      expect(duplicate_user.errors[:email]).to include("has already been taken")
    end

    it "is invalid with a password shorter than 12 characters" do
      user = build(:user, password: "shortpw")
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("is too short (minimum is 12 characters)")
    end
  end

  describe "email normalization" do
    it "normalizes email by trimming whitespace and downcasing" do
      user = create(:user, email: "  Test.User+demo@Example.COM  ", password: "longenough123")
      expect(user.reload.email).to eq("test.user+demo@example.com")
    end

    it "enforces uniqueness regardless of case/whitespace after normalization" do
      create(:user, email: "User@Example.com", password: "longenough123")
      dupe = build(:user, email: "  user@example.com  ", password: "anotherlong123")
      expect(dupe).not_to be_valid
      expect(dupe.errors[:email]).to include("has already been taken")
    end
  end
end
