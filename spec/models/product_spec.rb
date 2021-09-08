require "rails_helper"

RSpec.describe Product, type: :model do
  it "has a valid factory" do
    expect(build_stubbed(:product)).to be_valid
  end

  describe "Validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to validate_presence_of(:available_on) }
  end
end
