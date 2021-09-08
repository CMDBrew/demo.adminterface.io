class UserAddress < ApplicationRecord
  belongs_to :user

  validates :fullname, :address_line1, :city, :state, :zip_code, :country, presence: true

  def display_name
    id
  end

  def full_address
    [address_line1, address_line2, city, state, country, zip_code]
      .reject(&:blank?).join(", ")
  end
end
