class Admin::UserDecorator < ApplicationDecorator
  decorates :user

  def avatar_with_name
    image_tag(avatar(size: 24), class: "me-2") +
      content_tag(:span, object.name)
  end
end
