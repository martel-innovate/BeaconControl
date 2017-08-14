class CreateToilets < ActiveRecord::Migration
  def change
    create_table :toilets do |t|
      t.string :name
      t.integer :accessible
      t.integer :kind
      t.text :description
      t.references :account, index: true

      t.timestamps null: false
    end
  end
end
