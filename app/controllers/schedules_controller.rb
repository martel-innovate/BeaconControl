class SchedulesController < AdminController
  inherit_resources
  load_and_authorize_resource

  def new
    @schedule.build_coupon
    new!
  end

  def create
    @schedule.assign_attributes(schedule_params)

    if @schedule.save
      redirect_to schedules_path
    else
      render :new
    end
  end

  def update
     @schedule.assign_attributes(schedule_params)
     update! { schedules_path }
  end

  def schedule_params
    params.require(:schedule).permit(
      :name,
      :kind,
      :start_date,
      :end_date,
      :start_time,
      :end_time,
      :trigger_time,
      :beacon_id,
      :account_id,
      coupon_attributes: [
        :id, :template, :name, :title, :description,
        :logo_cache, :image_cache, :audio_cache,
        :unique_identifier_number, :identifier_number, :encoding_type,
        :button_label, :button_font_color, :button_background_color,
        :button_link,
        logo_attributes: [
          :id, :file, :type, :file_cache, :remove_file
        ],
        image_attributes: [
          :id, :file, :type, :file_cache, :remove_file
        ],
        audio_attributes: [
          :id, :file, :type, :file_cache, :remove_file
        ]
      ]
    )
  end
end
