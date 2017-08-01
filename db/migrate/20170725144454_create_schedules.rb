class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.string :name
      t.integer :kind, default: 1
      t.date :start_date
      t.date :end_date
      t.time :start_time
      t.time :end_time
      t.integer :trigger_time, default: 0
      t.references :beacon, index: true
      t.references :account, index: true

      t.timestamps null: false
    end
    add_foreign_key :schedules, :beacons
    add_foreign_key :schedules, :accounts
  end
end
