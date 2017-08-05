class CreateCustomerLogos < ActiveRecord::Migration
  def change
    create_table :customer_logos do |t|
      t.string :file
      t.references :contact, index: true

      t.timestamps null: false
    end
  end
end
