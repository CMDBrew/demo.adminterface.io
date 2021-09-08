require "rails_helper"

RSpec.describe "Admin::User", type: :feature do
  describe "manages records" do
    it "can create new record" do
      visit admin_users_path

      click_link("New User")

      within("#new_user") do
        fill_in("user[name]", with: Faker::Name.name)
        fill_in("user[email]", with: Faker::Internet.email)
        click_button("Create User")
      end

      expect(page).to have_content(/successfully created/i)
    end

    it "can filter records" do
      create(:user, name: "John")
      create(:user, name: "Mary")

      visit admin_users_path

      within("#new_q") do
        fill_in("q[name_contains]", with: "John")
        click_button("Filter")
      end

      expect(page).to have_content(/john/i)
    end

    it "can batch delete records" do
      user1 = create(:user, name: "John")
      user2 = create(:user, name: "Mary")

      visit admin_users_path

      within("#collection_selection") do
        check("batch_action_item_#{user1.id}", allow_label_click: true)
        check("batch_action_item_#{user2.id}", allow_label_click: true)
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
      user = create(:user)

      visit admin_users_path

      within("#user_#{user.id}") do
        click_link("Edit")
      end

      within("#edit_user") do
        fill_in("user[name]", with: Faker::Name.name)
        fill_in("user[email]", with: Faker::Internet.email)

        find('input[name="commit"]').click
      end

      expect(page).to have_content(/successfully updated/i)
    end

    it "can delete record" do
      user = create(:user)

      visit admin_user_path(user)

      click_link("Delete User")

      within("#modal-dialog-confirm") do
        click_button("Confirm")
      end

      expect(page).to have_content(/successfully destroyed/i)
    end
  end
end
