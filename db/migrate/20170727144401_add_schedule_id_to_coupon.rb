class AddScheduleIdToCoupon < ActiveRecord::Migration
  def change
    add_column :coupons, :schedule_id, :integer
    add_index :coupons, :schedule_id
  end
end
