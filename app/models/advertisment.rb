class Advertisment < ActiveRecord::Base
  SORTABLE_COLUMNS = %w(advertisments.name advertisments.start_date advertisments.end_date)
  SAME_TIME_ADS_MAXIMUM = 3

  validates_presence_of :name, :start_date, :end_date
  validate :valid_date_range

  mount_uploader :image, AdvertismentImageUploader

  scope :with_name, ->(name) {
    if name.present?
      where('advertisments.name LIKE :name', {name: "%#{name}%"})
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
                      'advertisments.created_at'
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
    errors.add(:end_date, "can't have more than 3 ads at same time") if has_more_than_3_ads_sametime?
  end

  def has_more_than_3_ads_sametime?
    duplicatable_ads = Advertisment.where("(start_date BETWEEN :start AND :end) OR (end_date BETWEEN :start AND :end)", start: start_date, end: end_date)
    duplicatable_ads = duplicatable_ads.where.not(id: id)
    (start_date..end_date).each do |date|
      defined_count = duplicatable_ads.select{ |ad| (ad.start_date..ad.end_date).include? date }.count
      return true if defined_count >= SAME_TIME_ADS_MAXIMUM
    end
    false
  end
end
