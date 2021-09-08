require "rails_helper"

RSpec.describe "Admin::Dashboard", type: :feature do
  it "lists out recent orders" do
    past_orders = create_list(:order, 2)
    recent_orders = create_list(:order, 10)

    visit admin_root_path

    past_orders.each do |order|
      expect(page).to_not have_content(order.user.name)
    end

    recent_orders.each do |order|
      expect(page).to have_content(order.user.name)
    end
  end

  it "lists out recent users" do
    past_users = create_list(:user, 2)
    recent_users = create_list(:user, 10)

    visit admin_root_path

    past_users.each do |user|
      expect(page).to_not have_content(user.name)
    end

    recent_users.each do |user|
      expect(page).to have_content(user.name)
    end
  end
end
