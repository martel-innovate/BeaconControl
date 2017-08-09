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

  def add_actions
    self.build_enter_action if self.enter_action.nil?
    self.build_exit_action if self.exit_action.nil?
  end
end
