class BusStopsController < AdminController
  inherit_resources
  load_and_authorize_resource

  has_scope :with_bus_stop_name, as: :bus_stop_name

  def index
    @bus_stop = BusStopDecorator.decorate_collection apply_scopes(collection).all
    index!
  end

  def create
    @bus_stop.assign_attributes(bus_stop_params)
    create! { bus_stops_path }
  end

  def update
    @bus_stop.assign_attributes(bus_stop_params)
    update! { bus_stops_path }
  end

  def batch_delete
    collection.destroy_all(id: params[:bus_stop_ids])
    redirect_to bus_stops_path
  end

  def bus_stop_params
    params.require(:bus_stop).permit(
      :name,
      :longtitude,
      :latitude,
      :radius,
      :account_id
    )
  end
end
