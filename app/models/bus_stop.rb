class BusStop < ActiveRecord::Base
  belongs_to :account

  scope :with_timestamp, ->(timestamp) {
    if timestamp.present?
      where('updated_at > ?', timestamp)
    end
  }

  scope :with_application_id, ->(application_id) {
    if application_id.present?
      where(application_id: application_id)
    end
  }

  scope :with_customer_id, ->(customer_id) {
    if customer_id.present?
      where(customer_id: customer_id)
    end
  }

  scope :with_bus_stop_name, ->(name) {
    if name.present?
      where('bus_stops.name LIKE :name', {name: "%#{name}%"})
    end
  }
end
