class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.string :name
      t.string :message
      t.string :type
      t.boolean :active

      t.references :geofence, index: true

      t.timestamps null: false
    end
  end
end
