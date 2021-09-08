require "rails_helper"

RSpec.describe User, type: :model do
  it "has a valid factory" do
    expect(build_stubbed(:user)).to be_valid
  end

  describe "Associations" do
    it { is_expected.to have_many(:orders).dependent(:destroy) }
    it { is_expected.to have_many(:user_addresses).dependent(:destroy) }
  end

  describe "Validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }

    it do
      user = build(:user, email: "test@test.com")
      expect(user).to validate_uniqueness_of(:email).case_insensitive
    end

    it_behaves_like "validators/email_format", "email"
  end
end
