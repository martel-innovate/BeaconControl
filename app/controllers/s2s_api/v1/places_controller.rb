module S2sApi
  module V1
    class PlacesController < BaseController
      inherit_resources
      load_and_authorize_resource

      PER_PAGE = 20

      has_scope :sorted, using: [:column, :direction], type: :hash, default: {
                         column: 'places.name',
                         direction: 'asc'
                       }
      has_scope :with_name, as: :place_name
      self.responder = S2sApiResponder

      actions :index, :show

      private

      def collection
        params[:page] ||= 1
        params[:per_page] ||= PER_PAGE
        apply_scopes(super).page(params[:page]).per(params[:per_page])
      end
    end
  end
end
