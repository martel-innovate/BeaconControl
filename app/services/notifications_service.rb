class NotificationsService
  include HTTParty
  base_uri 'https://fcm.googleapis.com/fcm'
  default_timeout 30
  format :json

  def initialize(notification)
    @notification = notification
  end

  def send_topic_notification
    params = {
      body: body.to_json,
      headers: {
        'Authorization' => "key=#{fcm_key}",
        'Content-Type' => 'application/json'
      }
    }

    response = self.class.post('/send', params)
    build_response(response)
  end

  private

  def fcm_key
    @notification.application.fcm_key
  end

  def body
    {
      to: "/topics/news",
      notification: {
        body: @notification.message,
        title: @notification.title,
        icon: "default",
        sound: "default"
      }
    }
  end

  def build_response(response)
    body = response.body || {}
    response_hash = { body: body, headers: response.headers, status_code: response.code, success: false }
    case response.code
    when 200
      response_hash[:message] = 'Push message was sent successfully.'
      response_hash[:success] = true
    when 400
      response_hash[:message] = 'Only applies for JSON requests. Indicates that the request could not be parsed as JSON, or it contained invalid fields.'
    when 401
      response_hash[:message] = 'There was an error authenticating the sender account. Please check the FCM key!'
    when 503
      response_hash[:message] = 'FCM Server is temporarily unavailable.'
    when 500..599
      response_hash[:message] = 'There was an internal error in the FCM server while trying to process the request.'
    end
    response_hash
  end
end