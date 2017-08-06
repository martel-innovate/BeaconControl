class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :application, index: true
      t.string :title
      t.text :message

      t.timestamps null: false
    end
    add_foreign_key :notifications, :applications
  end
end
