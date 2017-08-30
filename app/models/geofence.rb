class Geofence < ActiveRecord::Base
  belongs_to :account

  has_one :enter_action, -> { where(type: 'Action::Enter') }, class_name: 'Action'
  has_one :exit_action, -> { where(type: 'Action::Exit') }, class_name: 'Action'
  accepts_nested_attributes_for :enter_action, :exit_action

  scope :with_geofence_name, ->(name) {
    if name.present?
      where('geofences.name LIKE :name', {name: "%#{name}%"})
    end
  }

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

  def add_actions
    self.build_enter_action if self.enter_action.nil?
    self.build_exit_action if self.exit_action.nil?
  end
end
