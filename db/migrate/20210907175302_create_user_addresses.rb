class CreateUserAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :user_addresses do |t|
      t.references :user, null: false, foreign_key: true
      t.string :fullname
      t.string :address_line1
      t.string :address_line2
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :country
      t.integer :position

      t.timestamps
    end
  end
end
