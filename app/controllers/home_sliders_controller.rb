class HomeSlidersController < AdminController
  inherit_resources
  load_and_authorize_resource

  PER_PAGE = 10

  has_scope :sorted, using: [:column, :direction], type: :hash, default: {
                     column: 'home_sliders.created_at',
                     direction: 'desc'
                   }
  has_scope :with_name, as: :home_slider_name


  def new
    @home_slider = resource.decorate
    new!
  end

  def index
    params[:page] ||= 1
    params[:per_page] ||= PER_PAGE
    @home_sliders = HomeSliderDecorator.decorate_collection apply_scopes(collection).page(params[:page]).per(params[:per_page])
    index!
  end

  def create
    create! { home_sliders_path }
  end

  def update
    @home_slider.assign_attributes(home_slider_params)
    update! { home_sliders_path }
  end

  def edit
    edit!
  end

  def batch_delete
    collection.destroy_all(id: params[:home_slider_ids])
    redirect_to home_sliders_path
  end

  private

    def home_slider_params
      params.require(:home_slider).permit(:name, :start_date, :end_date, :slider1, :slider2)
    end
end

