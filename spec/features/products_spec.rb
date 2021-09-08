require "rails_helper"

RSpec.describe "Admin::Product", type: :feature do
  describe "manages records" do
    it "can create new record" do
      visit admin_products_path

      click_link("New Product")

      within("#new_product") do
        fill_in("product[title]", with: Faker::Book.title)
        fill_in("product[price]", with: Faker::Number.decimal(l_digits: 2))
        page.execute_script("flatpickr('#product_available_on', {})._input.value = '#{Time.current.strftime("%Y-%d-%m")}'")
        click_button("Create Product")
      end

      expect(page).to have_content(/successfully created/i)
    end

    it "can filter records" do
      create(:product, title: "TV")
      create(:product, title: "Laptop")

      visit admin_products_path

      within("#new_q") do
        fill_in("q[title_contains]", with: "TV")
        click_button("Filter")
      end

      expect(page).to have_content(/tv/i)
    end

    it "can batch delete records" do
      product1 = create(:product)
      product2 = create(:product)

      visit admin_products_path

      within("#collection_selection") do
        check("batch_action_item_#{product1.id}", allow_label_click: true)
        check("batch_action_item_#{product2.id}", allow_label_click: true)
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
      product = create(:product)

      visit admin_products_path

      within("#product_#{product.id}") do
        click_link("Edit")
      end

      within("#edit_product") do
        fill_in("product[title]", with: Faker::Book.title)
        fill_in("product[price]", with: Faker::Number.decimal(l_digits: 2))

        find('input[name="commit"]').click
      end

      expect(page).to have_content(/successfully updated/i)
    end

    it "can delete record" do
      product = create(:product)

      visit admin_product_path(product)

      click_link("Delete Product")

      within("#modal-dialog-confirm") do
        click_button("Confirm")
      end

      expect(page).to have_content(/successfully destroyed/i)
    end

    context "with scopes" do
      it "shows correct records available scope" do
        available_product = create(:product, available_on: Time.current, featured: false)
        draft_product = create(:product, available_on: Time.current + 1.day, featured: false)

        visit admin_products_path(scope: "available")

        expect(page).to have_content(available_product.title)
        expect(page).to_not have_content(draft_product.title)
      end

      it "shows correct records drafts scope" do
        available_product = create(:product, available_on: Time.current, featured: false)
        draft_product = create(:product, available_on: Time.current + 1.day, featured: false)

        visit admin_products_path(scope: "drafts")

        expect(page).to have_content(draft_product.title)
        expect(page).to_not have_content(available_product.title)
      end

      it "shows correct records featured scope" do
        not_featured_product = create(:product, featured: false)
        featured_product = create(:product, featured: true)

        visit admin_products_path(scope: "featured")

        expect(page).to have_content(featured_product.title)
        expect(page).to_not have_content(not_featured_product.title)
      end
    end
  end
end
