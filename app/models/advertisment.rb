class Advertisment < ActiveRecord::Base
  SORTABLE_COLUMNS = %w(advertisments.name advertisments.start_date advertisments.end_date)

  scope :with_name, ->(name) {
    if name.present?
      where('advertisments.name LIKE :name', {name: "%#{name}%"})
    end
  }

  scope :sorted, ->(column, direction) {
    sorted_column = if SORTABLE_COLUMNS.include?(column)
                      column
                    else
                      'advertisments.name'
                    end

    direction = if %w[asc desc].include? direction
                  direction
                else
                  'asc'
                end

    order("#{sorted_column} #{direction}")
  }
end
