class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :type
      t.string :name
      t.string :address
      t.string :zip_code
      t.string :city
      t.text :opening_hours
      t.boolean :has_opening_hours, default: true
      t.text :entrance
      t.string :website
      t.string :phone
      t.string :email

      t.timestamps null: false
    end
  end
end
