module FacilitiesManagement
  module RM3830
    module Admin
      class SublotServicesController < FacilitiesManagement::Admin::FrameworkController
        before_action :set_framework_has_expired
        before_action :set_supplier, :set_lot, :redirect_if_lot_out_of_range
        before_action :full_services
        before_action :set_service_data, only: :show
        before_action :set_lot_1a_service_data, if: proc { @lot == '1a' }

        def show; end

        def update
          if @lot == '1a'
            update_lot_1a
          else
            update_lots
          end
        end

        private

        def set_service_data
          @lot_name = "Sub-lot #{@lot} services"
          lot_data = @supplier.lot_data[@lot]
          supplier_services = lot_data['services'] || []
          setup_checkboxes(supplier_services)
        end

        def setup_checkboxes(supplier_services)
          @supplier_rate_data_checkboxes = @full_services.map do |service|
            service['work_package'].to_h do |work_pckg|
              code = work_pckg['code']
              [code, supplier_services.include?(code)]
            end
          end.inject(:merge)
        end

        def set_lot_1a_service_data
          setup_supplier_data_ratecard
          setup_variance_supplier_data
        end

        def latest_rate_card
          @latest_rate_card ||= RateCard.latest
        end

        def setup_supplier_data_ratecard
          @supplier_data_ratecard_prices = latest_rate_card[:data][:Prices][@supplier_id]
          @supplier_data_ratecard_prices.deep_stringify_keys!

          @supplier_data_ratecard_discounts = latest_rate_card[:data][:Discounts][@supplier_id]
          @supplier_data_ratecard_discounts.deep_stringify_keys!
        end

        def setup_variance_supplier_data
          @variance_supplier_data = latest_rate_card[:data][:Variances][@supplier_id]
        end
      end
    end
  end
end
