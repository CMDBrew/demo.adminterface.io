class Product < ApplicationRecord
  has_one_attached :image
  has_many :line_items, dependent: :nullify

  validates :title, :price, :available_on, presence: true

  scope :available, -> { where("available_on <= ?", Date.today) }
  scope :drafts, -> { where("available_on > ?", Date.today) }
  scope :featured, -> { where(featured: true) }
end
