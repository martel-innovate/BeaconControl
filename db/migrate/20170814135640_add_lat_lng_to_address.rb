class AddLatLngToAddress < ActiveRecord::Migration
  def up
    add_column :addresses, :addressable_id, :integer
    add_column :addresses, :addressable_type, :string
    add_column :addresses, :longtitude, :decimal, precision: 15, scale: 11
    add_column :addresses, :latitude, :decimal, precision: 15, scale: 11

    remove_index :addresses, :admin_id
    remove_column :addresses, :admin_id

    add_index :addresses, [:addressable_id, :addressable_type]
  end

  def down
    remove_index :addresses, [:addressable_id, :addressable_type]

    remove_column :addresses, :addressable_id, :integer
    remove_column :addresses, :addressable_type, :string
    remove_column :addresses, :longtitude, :decimal, precision: 15, scale: 11
    remove_column :addresses, :latitude, :decimal, precision: 15, scale: 11

    add_column :addresses, :admin_id, :integer
    add_index :addresses, :admin_id
  end
end
