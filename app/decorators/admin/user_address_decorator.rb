class Admin::UserAddressDecorator < ApplicationDecorator
  decorates :user_address
  decorates_association :user, with: Admin::UserDecorator

  delegate :avatar_with_name, to: :user, prefix: true
end
