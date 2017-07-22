class GeofencesController < AdminController
  inherit_resources
  load_and_authorize_resource

  def new
    @geofence.add_actions
    new!
  end

  def create
    @geofence.assign_attributes(geofence_params)
    if @geofence.save
      @geofence.enter_action.save
      @geofence.exit_action.save
    end
    create! { geofences_path }
  end

  def update
    @geofence.assign_attributes(geofence_params)
    update! { geofences_path }
  end

  def edit
    @geofence.add_actions
    edit!
  end

  def geofence_params
    params.require(:geofence).permit(
      :name,
      :active,
      :longtitude,
      :latitude,
      :radius,
      :account_id,
      enter_action_attributes: [:active, :name, :message],
      exit_action_attributes: [:active, :name, :message]
    )
  end
end
