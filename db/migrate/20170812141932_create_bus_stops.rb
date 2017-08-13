class CreateBusStops < ActiveRecord::Migration
  def change
    create_table :bus_stops do |t|
      t.string :name
      t.decimal :longtitude, precision: 15, scale: 11
      t.decimal :latitude, precision: 15, scale: 11
      t.integer :radius

      t.references :account, index: true

      t.timestamps null: false
    end
  end
end
