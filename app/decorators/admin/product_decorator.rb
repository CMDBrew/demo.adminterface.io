class Admin::ProductDecorator < ApplicationDecorator
  decorates :product
  decorates_association :user, with: Admin::UserDecorator
end
