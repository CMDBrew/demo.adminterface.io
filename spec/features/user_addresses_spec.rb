require "rails_helper"

RSpec.describe "Admin::UserAddress", type: :feature do
  let(:user) { create(:user) }

  describe "manages records" do
    it "can create new record" do
      visit admin_user_user_addresses_path(user)

      click_link("New Address")

      within("#new_user_address") do
        fill_in("user_address[fullname]", with: Faker::Name.name)
        fill_in("user_address[address_line1]", with: Faker::Address.street_name)
        fill_in("user_address[city]", with: Faker::Address.city)
        fill_in("user_address[state]", with: Faker::Address.state)
        fill_in("user_address[zip_code]", with: Faker::Address.zip_code)
        find("#user_address_country").set("Canada")
        click_button("Create Address")
      end

      expect(page).to have_content(/successfully created/i)
    end

    it "can filter records" do
      create(:user_address, user: user, fullname: "John")
      create(:user_address, user: user, fullname: "Mary")

      visit admin_user_user_addresses_path(user)

      within("#new_q") do
        fill_in("q[fullname_contains]", with: "John")
        click_button("Filter")
      end

      expect(page).to have_content(/john/i)
    end

    it "can batch delete records" do
      address1 = create(:user_address, user: user, fullname: "John")
      address2 = create(:user_address, user: user, fullname: "Mary")

      visit admin_user_user_addresses_path(user)

      within("#collection_selection") do
        check("batch_action_item_#{address1.id}", allow_label_click: true)
        check("batch_action_item_#{address2.id}", allow_label_click: true)
      end

      click_link("Batch Actions")

      within(".dropdown-menu.show") do
        click_link("Delete Selected")
      end

      within("#modal-dialog-confirm") do
        click_button("Confirm")
      end

      expect(page).to have_content(/successfully deleted/i)
    end

    it "can update record" do
      address = create(:user_address, user: user)

      visit admin_user_user_addresses_path(user)

      within("#user_address_#{address.id}") do
        click_link("Edit")
      end

      within("#edit_user_address") do
        fill_in("user_address[fullname]", with: Faker::Name.name)
        fill_in("user_address[address_line1]", with: Faker::Address.street_name)
        fill_in("user_address[city]", with: Faker::Address.city)
        fill_in("user_address[state]", with: Faker::Address.state)
        fill_in("user_address[zip_code]", with: Faker::Address.zip_code)
        find("#user_address_country").set("Canada")

        find('input[name="commit"]').click
      end

      expect(page).to have_content(/successfully updated/i)
    end

    it "can delete record" do
      address = create(:user_address, user: user)

      visit admin_user_user_address_path(user, address)

      click_link("Delete Address")

      within("#modal-dialog-confirm") do
        click_button("Confirm")
      end

      expect(page).to have_content(/successfully destroyed/i)
    end
  end
end
