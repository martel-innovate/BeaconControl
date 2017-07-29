###
# Copyright (c) 2015, Upnext Technologies Sp. z o.o.
# All rights reserved.
#
# This source code is licensed under the BSD 3-Clause License found in the
# LICENSE.txt file in the root directory of this source tree.
###

module S2sApi
  module V1
    class schedulesController < BaseController
      inherit_resources
      load_and_authorize_resource

      self.responder = S2sApiResponder

      actions :index
      def index
        render json: to_custom_json(@schedules.where(search_params))
      end

      private

      def to_custom_json(schedules)
        schedules.map { |schedule|
          {
            id: schedule.id,
            name: schedule.name,
            beacon: {
              id: schedule.beacon.id,
              name: schedule.beacon.name
            },
            type: schedule.kind_name,
            start_date: schedule.start_date,
            end_date: schedule.end_date,
            start_time: schedule.start_time,
            end_time: schedule.end_time,
            template: {
              id: schedule.coupon.id,
              template: I18n.t('templates')[schedule.coupon.template.to_sym],
              name: schedule.coupon.name,
              title: schedule.coupon.title,
              description: schedule.coupon.description,
              identifier_number: schedule.coupon.identifier_number,
              unique_identifier_number: schedule.coupon.unique_identifier_number,
              encoding_type: schedule.coupon.encoding_type,
              button_font_color: schedule.coupon.button_font_color,
              button_background_color: schedule.coupon.button_background_color,
              button_label: schedule.coupon.button_label,
              button_link: schedule.coupon.button_link,
              logo: {
                url: schedule.coupon.try(:logo).try(:file_url)
              },
              audio: {
                url: schedule.coupon.try(:audio).try(:file_url)
              },
              image: {
                url: schedule.coupon.try(:image).try(:file_url)
              }
            }
          }
        }.to_json
      end

      def collection
        super.includes(:beacon, :coupon)
      end

      def search_params
        params.permit(:active)
      end
    end
  end
end
