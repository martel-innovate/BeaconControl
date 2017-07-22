class CreateGeofences < ActiveRecord::Migration
  def change
    create_table :geofences do |t|
      t.string :name
      t.boolean :active
      t.decimal :longtitude, precision: 15, scale: 11
      t.decimal :latitude, precision: 15, scale: 11
      t.integer :radius

      t.references :account, index: true

      t.timestamps null: false
    end
  end
end
