class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :street
      t.string :zip
      t.string :city
      t.references :admin, foreign_key: true, index: true

      t.timestamps null: false
    end
  end
end
