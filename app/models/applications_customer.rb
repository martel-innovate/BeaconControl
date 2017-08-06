class ApplicationsCustomer < ActiveRecord::Base
  belongs_to :admin, foreign_key: :customer_id
  belongs_to :application
end
