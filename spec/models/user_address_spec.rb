require "rails_helper"

RSpec.describe UserAddress, type: :model do
  it "has a valid factory" do
    expect(build_stubbed(:user_address)).to be_valid
  end

  describe "Associations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "Validations" do
    it { is_expected.to validate_presence_of(:user).with_message(/must exist/) }
    it { is_expected.to validate_presence_of(:fullname) }
    it { is_expected.to validate_presence_of(:address_line1) }
    it { is_expected.to validate_presence_of(:city) }
    it { is_expected.to validate_presence_of(:state) }
    it { is_expected.to validate_presence_of(:zip_code) }
    it { is_expected.to validate_presence_of(:country) }
  end
end
