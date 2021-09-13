class LineItem < ApplicationRecord
  belongs_to :order
  belongs_to :product, counter_cache: true
end
