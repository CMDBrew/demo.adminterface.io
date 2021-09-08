require "rails_helper"

RSpec.describe Order, type: :model do
  it "has a valid factory" do
    expect(build_stubbed(:order)).to be_valid
  end

  describe "Associations" do
    it { is_expected.to have_many(:line_items).dependent(:destroy) }
    it { is_expected.to belong_to(:user) }
  end

  describe "Validations" do
    it { is_expected.to validate_presence_of(:user).with_message(/must exist/) }
  end
end
