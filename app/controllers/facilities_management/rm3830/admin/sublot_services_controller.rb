module FacilitiesManagement
  module RM3830
    module Admin
      class SublotServicesController < FacilitiesManagement::Admin::FrameworkController
        before_action :set_supplier, :set_lot, :redirect_if_lot_out_of_range
        before_action :full_services
        before_action :set_service_data, only: :edit
        before_action :set_lot_1a_service_data, :initialize_errors, if: proc { @lot == '1a' }

        def edit; end

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

        def initialize_errors
          @invalid_services = {}
        end

        def update_lots
          update_checkboxes
          redirect_to facilities_management_rm3830_admin_supplier_framework_data_path
        end

        def update_lot_1a
          @services_validator = SublotServicesValidator.new(params, latest_rate_card, @supplier_data_ratecard_prices, @supplier_data_ratecard_discounts, @variance_supplier_data)

          if @services_validator.save
            update_checkboxes
            redirect_to facilities_management_rm3830_admin_supplier_framework_data_path
          else
            @supplier.replace_services_for_lot(params[:checked_services], @lot)
            set_service_data
            @supplier_data_ratecard_prices = @services_validator.supplier_data_ratecard_prices
            @supplier_data_ratecard_discounts = @services_validator.supplier_data_ratecard_discounts
            @variance_supplier_data = @services_validator.variance_supplier_data
            @invalid_services = @services_validator.invalid_services
            render :edit
          end
        end

        def update_checkboxes
          @supplier.replace_services_for_lot(params[:checked_services], @lot)
          @supplier.save
        end
      end
    end
  end
end
