class PlacesController < AdminController
  inherit_resources
  load_and_authorize_resource

  PER_PAGE = 10

  has_scope :sorted, using: [:column, :direction], type: :hash, default: {
                     column: 'places.name',
                     direction: 'asc'
                   }
  has_scope :with_name, as: :place_name


  def new
    @place = resource.decorate
    new!
  end

  def index
    params[:page] ||= 1
    params[:per_page] ||= PER_PAGE
    @places = PlaceDecorator.decorate_collection apply_scopes(collection).page(params[:page]).per(params[:per_page])
    index!
  end

  def create
    create! { places_path }
  end

  def update
    @place.assign_attributes(place_params)
    update! { places_path }
  end

  def edit
    edit!
  end

  def batch_delete
    collection.destroy_all(id: params[:place_ids])
    redirect_to places_path
  end

  private

  def place_params
    params.require(:place).permit(:type, :name, :address, :zip_code, :city, :opening_hours, :has_opening_hours, :entrance, :website, :phone, :email)
  end
end

