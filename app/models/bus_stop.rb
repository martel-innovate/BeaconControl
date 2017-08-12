class BusStop < ActiveRecord::Base
  belongs_to :account

  scope :with_bus_stop_name, ->(name) {
    if name.present?
      where('bus_stops.name LIKE :name', {name: "%#{name}%"})
    end
  }
end
