class ChangeDefaultActive < ActiveRecord::Migration
  def change
    change_column_default :geofences, :active, true
  end
end
