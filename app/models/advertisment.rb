class Advertisment < ActiveRecord::Base
  SORTABLE_COLUMNS = %w(advertisments.name advertisments.start_date advertisments.end_date)

  # validates_presence_of :name, :start_date, :end_date, :image
  mount_uploader :image, AdvertismentImageUploader

  scope :with_name, ->(name) {
    if name.present?
      where('advertisments.name LIKE :name', {name: "%#{name}%"})
    end
  }

  scope :sorted, ->(column, direction) {
    sorted_column = if SORTABLE_COLUMNS.include?(column)
                      column
                    else
                      'advertisments.created_at'
                    end

    direction = if %w[asc desc].include? direction
                  direction
                else
                  'asc'
                end

    order("#{sorted_column} #{direction}")
  }

  scope :active, -> { where("? BETWEEN start_date AND end_date", Time.now.to_date)}
end
