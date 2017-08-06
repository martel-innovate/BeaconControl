class Notification < ActiveRecord::Base
  validates :application, presence: true
  belongs_to :application
end
