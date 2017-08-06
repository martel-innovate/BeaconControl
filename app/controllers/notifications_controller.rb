class NotificationsController < AdminController
  inherit_resources
  load_and_authorize_resource

  def index
    @notifications = Notification.order(created_at: :desc)
  end

  def new
    @notification = Notification.new
  end

  def create
    @notification = Notification.new(notification_params)
    if @notification.save
      redirect_to notifications_path
    else
      render :new
    end
  end

  private

    def notification_params
      params.require(:notification).permit(:application_id, :title, :message)
    end
end

