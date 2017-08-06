class CreateApplicationsCustomers < ActiveRecord::Migration
  def change
    create_table :applications_customers do |t|
      t.belongs_to :applications, index: true

      t.timestamps null: false
    end

    add_reference :applications_customers, :customer, references: :admins, index: true
  end
end
