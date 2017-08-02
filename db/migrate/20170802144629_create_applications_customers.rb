class CreateApplicationsCustomers < ActiveRecord::Migration
  def change
    create_table :applications_customers do |t|
      t.belongs_to :applications, index: true, foreign_key: true

      t.timestamps null: false
    end

    add_reference :applications_customers, :customer, references: :admins, index: true
    add_foreign_key :applications_customers, :admins, column: :customer_id
  end
end
