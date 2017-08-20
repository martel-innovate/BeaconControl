module S2sApi
  module V1
    class AdvertismentsController < BaseController
      inherit_resources
      load_and_authorize_resource

      PER_PAGE = 20

      has_scope :sorted, using: [:column, :direction], type: :hash, default: {
                         column: 'advertisments.created_at',
                         direction: 'desc'
                       }
      has_scope :with_name, as: :advertisment_name
      self.responder = S2sApiResponder

      actions :index

      private

      def collection
        params[:page] ||= 1
        params[:per_page] ||= PER_PAGE
        apply_scopes(super).active.page(params[:page]).per(params[:per_page])
      end
    end
  end
end
