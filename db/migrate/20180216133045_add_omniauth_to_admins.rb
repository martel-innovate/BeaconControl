class AddOmniauthToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :provider, :string
    add_column :admins, :uid, :string
    add_column :admins, :current_access_token, :text
  end
end
