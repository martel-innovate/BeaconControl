class PlacesController < InheritedResources::Base
  before_filter :authenticate_admin!

  private

    def place_params
      params.require(:place).permit(:type, :name, :address, :zip_code, :city, :opening_hours, :has_opening_hours, :entrance, :website, :phone, :email)
    end
end

