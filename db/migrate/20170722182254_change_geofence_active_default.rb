class ChangeGeofenceActiveDefault < ActiveRecord::Migration
  def change
    change_column_default :geofences, :active, false
  end
end
