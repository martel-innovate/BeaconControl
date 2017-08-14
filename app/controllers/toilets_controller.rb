class ToiletsController < AdminController
  inherit_resources
  load_and_authorize_resource

  has_scope :with_toilet_name, as: :toilet_name

  def new
    @toilet.build_address
    new!
  end

  def index
    @toilets = ToiletDecorator.decorate_collection apply_scopes(collection).all
    index!
  end

  def create
    create! { toilets_path } if @toilet.update_attributes(toilet_params)
  end

  def update
    @toilet.assign_attributes(toilet_params)
    update! { toilets_path }
  end

  def edit
    @toilet.add_actions
    edit!
  end

  def batch_delete
    collection.destroy_all(id: params[:toilet_ids])
    redirect_to toilets_path
  end

  def toilet_params
    params.require(:toilet).permit(
      :name,
      :kind,
      :accessible,
      :kind,
      :description,
      :account_id,
      address_attributes: [:street, :zip, :city, :latitude, :longtitude]
    )
  end
end
