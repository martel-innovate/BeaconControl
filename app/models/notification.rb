class Notification < ActiveRecord::Base
  belongs_to :application

  validates :application, presence: true
  validate :send_request_to_fcm, on: :create

  private

  def send_request_to_fcm
    notifications_service = NotificationsService.new(self)
    response = notifications_service.send_topic_notification
    unless response[:success]
      errors.add(:fcm, response[:message])
    end
  end
end
