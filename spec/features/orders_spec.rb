require "rails_helper"

RSpec.describe "Admin::Order", type: :feature do
  describe "manages records" do
    it "can filter records" do
      order = create(:order, user: create(:user, name: "John"))
      create(:order)

      visit admin_orders_path

      within("#new_q") do
        fill_in("q[total_price_equals]", with: order.total_price)
        click_button("Filter")
      end

      expect(page).to have_content(/john/i)
    end

    it "can batch update records" do
      order1 = create(:order)
      order2 = create(:order)

      visit admin_orders_path

      within("#collection_selection") do
        check("batch_action_item_#{order1.id}", allow_label_click: true)
        check("batch_action_item_#{order2.id}", allow_label_click: true)
      end

      click_link("Batch Actions")

      within(".dropdown-menu.show") do
        click_link("Update Status Selected")
      end

      within("#modal-dialog-confirm") do
        click_button("Confirm")
      end

      expect(page).to have_content(/successfully updated/i)
    end

    context "with scopes" do
      it "shows correct records in_progress scope" do
        in_progress_order = create(:order, checked_out_at: nil)
        completed_order = create(:order, checked_out_at: Time.current)

        visit admin_orders_path(scope: "in_progress")

        expect(page).to have_content("##{in_progress_order.id}")
        expect(page).to_not have_content("##{completed_order.id}")
      end

      it "shows correct records completed scope" do
        in_progress_order = create(:order, checked_out_at: nil)
        completed_order = create(:order, checked_out_at: Time.current)

        visit admin_orders_path(scope: "completed")

        expect(page).to have_content("##{completed_order.id}")
        expect(page).to_not have_content("##{in_progress_order.id}")
      end
    end
  end
end
