class User < ApplicationRecord
  has_many :orders, dependent: :destroy
  has_many :user_addresses, dependent: :destroy
  has_rich_text :biography

  accepts_nested_attributes_for :user_addresses, reject_if: :all_blank, allow_destroy: true

  validates :name, :email, presence: true
end
