###
# Copyright (c) 2015, Upnext Technologies Sp. z o.o.
# All rights reserved.
#
# This source code is licensed under the BSD 3-Clause License found in the
# LICENSE.txt file in the root directory of this source tree.
###

module S2sApi
  module V1
    class SchedulesController < BaseController
      inherit_resources
      load_and_authorize_resource

      PER_PAGE = 20

      self.responder = S2sApiResponder
      has_scope :with_customer_id, as: :customer_id
      has_scope :with_application_id, as: :application_id

      actions :index

      private
      def collection
        params[:page] ||= 1
        params[:per_page] ||= PER_PAGE
        apply_scopes(super).page(params[:page]).per(params[:per_page])
      end
    end
  end
end
