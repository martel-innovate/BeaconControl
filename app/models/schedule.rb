class Schedule < ActiveRecord::Base
  has_one :coupon
  belongs_to :beacon

  accepts_nested_attributes_for :coupon, update_only: true

  validates :start_date, :start_time, :end_time, :name, presence: true

  scope :with_active, ->(active) {
    if active.present?
      where(active: active)
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

  def kind_name
    trigger_time > 0 ? 'Nach x Minuten' : 'Sofort'
  end

  def duration
    kind == 2 ? (end_time.hour - start_time.hour).to_s + ' Stunden': (end_date - start_date).to_i.to_s + ' Tage'
  end

  def duration_in_hours
    persisted? ? end_time.hour - start_time.hour : 1
  end
end
