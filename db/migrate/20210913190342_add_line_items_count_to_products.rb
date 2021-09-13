class AddLineItemsCountToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :line_items_count, :integer, default: 0

    Product.reset_column_information
    reversible do |dir|
      dir.up do
        Product.find_each do |product|
          Product.reset_counters(product.id, :line_items)
        end
      end
    end
  end
end
