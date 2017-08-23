class HomeSlider < ActiveRecord::Base
  SORTABLE_COLUMNS = %w(home_sliders.name home_sliders.start_date home_sliders.end_date)
  SAME_TIME_SLIDER_MAXIMUM = 1

  validates_presence_of :name, :start_date, :end_date
  validate :valid_date_range

  mount_uploader :slider1, HomeSliderImageUploader
  mount_uploader :slider2, HomeSliderImageUploader

  scope :with_name, ->(name) {
    if name.present?
      where('home_sliders.name LIKE :name', {name: "%#{name}%"})
    end
  }

  scope :sorted, ->(column, direction) {
    sorted_column = if SORTABLE_COLUMNS.include?(column)
                      column
                    else
                      'home_sliders.created_at'
                    end

    direction = if %w[asc desc].include? direction
                  direction
                else
                  'asc'
                end

    order("#{sorted_column} #{direction}")
  }

  scope :active, -> { where("? BETWEEN start_date AND end_date", Time.now.to_date) }

  private

  def valid_date_range
    return unless start_date && end_date
    return errors.add(:end_date, "can't be smaller than Start date") if start_date > end_date
    errors.add(:end_date, "only one slider can be defined at the same time") if has_more_than_1_slider_sametime?
  end

  def has_more_than_1_slider_sametime?
    duplicatable_sliders = HomeSlider.where("(start_date BETWEEN :start AND :end) OR (end_date BETWEEN :start AND :end)", start: start_date, end: end_date)
    duplicatable_sliders = duplicatable_sliders.where.not(id: id)
    (start_date..end_date).each do |date|
      defined_count = duplicatable_sliders.select{ |ad| (ad.start_date..ad.end_date).include? date }.count
      return true if defined_count >= SAME_TIME_SLIDER_MAXIMUM
    end
    false
  end
end
