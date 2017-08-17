class AdvertismentsController < AdminController
  inherit_resources
  load_and_authorize_resource

  PER_PAGE = 10

  has_scope :sorted, using: [:column, :direction], type: :hash, default: {
                     column: 'advertisments.created_at',
                     direction: 'desc'
                   }
  has_scope :with_name, as: :advertisment_name


  def new
    @advertisment = resource.decorate
    new!
  end

  def index
    params[:page] ||= 1
    params[:per_page] ||= PER_PAGE
    @advertisments = AdvertismentDecorator.decorate_collection apply_scopes(collection).page(params[:page]).per(params[:per_page])
    index!
  end

  def create
    create! { advertisments_path }
  end

  def update
    @advertisment.assign_attributes(advertisment_params)
    update! { advertisments_path }
  end

  def edit
    edit!
  end

  def batch_delete
    collection.destroy_all(id: params[:advertisment_ids])
    redirect_to advertisments_path
  end

  private

    def advertisment_params
      params.require(:advertisment).permit(:name, :start_date, :end_date, :image)
    end
end

