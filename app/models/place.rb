class Place < ActiveRecord::Base
  SORTABLE_COLUMNS = %w(places.name places.address places.city)

  scope :with_name, ->(name) {
    if name.present?
      where('places.name LIKE :name', {name: "%#{name}%"})
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

  scope :sorted, ->(column, direction) {
    sorted_column = if SORTABLE_COLUMNS.include?(column)
                      column
                    else
                      'places.name'
                    end

    direction = if %w[asc desc].include? direction
                  direction
                else
                  'asc'
                end

    order("#{sorted_column} #{direction}")
  }
end
