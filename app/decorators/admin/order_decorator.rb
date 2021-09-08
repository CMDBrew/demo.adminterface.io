class Admin::OrderDecorator < ApplicationDecorator
  decorates :order
  decorates_association :user, with: Admin::UserDecorator
end
