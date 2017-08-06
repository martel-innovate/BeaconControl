class AddFcmKeyToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :fcm_key, :string
  end
end
