class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :position
      t.string :phone_number
      t.references :admin, foreign_key: true, index: true

      t.timestamps null: false
    end
  end
end
