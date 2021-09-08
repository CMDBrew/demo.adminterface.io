class User < ApplicationRecord
  has_many :orders, dependent: :destroy
  has_many :user_addresses, dependent: :destroy
  has_rich_text :biography

  accepts_nested_attributes_for :user_addresses, reject_if: :all_blank, allow_destroy: true

  validates :name, presence: true
  validates :email, email_format: true, uniqueness: { case_sensitive: false }, presence: true

  def avatar(size: 64)
    "https://source.boringavatars.com/beam/#{size}/#{name}"
  end
end
