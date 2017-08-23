class CreateHomeSliders < ActiveRecord::Migration
  def change
    create_table :home_sliders do |t|
      t.string :name
      t.date :start_date
      t.date :end_date
      t.string :slider1
      t.string :slider2

      t.timestamps null: false
    end
  end
end
