class Admin::OrderDecorator < ApplicationDecorator
  decorates :order
  decorates_association :user, with: Admin::UserDecorator

  delegate :avatar_with_name, to: :user, prefix: true
end
