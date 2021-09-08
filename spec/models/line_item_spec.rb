require "rails_helper"

RSpec.describe LineItem, type: :model do
  it "has a valid factory" do
    expect(build_stubbed(:line_item)).to be_valid
  end

  describe "Associations" do
    it { is_expected.to belong_to(:order) }
    it { is_expected.to belong_to(:product) }
  end

  describe "Validations" do
    it { is_expected.to validate_presence_of(:order).with_message(/must exist/) }
    it { is_expected.to validate_presence_of(:product).with_message(/must exist/) }
  end
end
