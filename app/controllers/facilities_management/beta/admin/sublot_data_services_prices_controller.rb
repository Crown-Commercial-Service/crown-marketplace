module FacilitiesManagement
  module Beta
    module Admin
      class SublotDataServicesPricesController < FacilitiesManagement::Beta::FrameworkController
        rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
        rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
        rescue_from NoMethodError, with: :render_no_method_error_response

        def render_unprocessable_entity_response(exception)
          logger.error exception.message
          redirect_to facilities_management_beta_admin_path, flash: { error: 'Invalid supplier ID lot 1a processing' }
        end

        def render_not_found_response(exception)
          logger.error exception.message
          redirect_to facilities_management_beta_admin_path, flash: { error: 'Invalid supplier ID lot 1a not found' }
        end

        def render_no_method_error_response(exception)
          logger.error exception.message
          redirect_to facilities_management_beta_admin_path, flash: { error: 'Invalid supplier ID lota method not found' }
        end

        def index
          @list_service_types = ['Direct Award Discount (%)', 'General office - Customer Facing (£)', 'General office - Non Customer Facing (£)', 'Call Centre Operations (£)', 'Warehouses (£)', 'Restaurant and Catering Facilities (£)', 'Pre-School (£)', 'Primary School (£)', 'Secondary Schools (£)', 'Special Schools (£)', 'Universities and Colleges (£)', 'Community - Doctors, Dentist, Health Clinic (£)', 'Nursing and Care Homes (£)']

          supplier_data = FacilitiesManagement::Admin::SuppliersAdmin.find(params[:id])['data']
          @supplier_name = supplier_data['supplier_name']

          lot1a_data = supplier_data['lots'].select { |data| data['lot_number'] == '1a' }
          supplier_services = lot1a_data[0]['services']

          setup_supplier_data_ratecard

          rate_card = CCS::FM::RateCard.latest
          setup_variance_supplier_data(rate_card)

          @services = FacilitiesManagement::Admin::StaticDataAdmin.services
          @work_packages = FacilitiesManagement::Admin::StaticDataAdmin.work_packages

          @rates = FacilitiesManagement::Admin::Rates.all
          @work_packages_with_rates = FacilitiesManagement::Beta::Supplier::SupplierRatesHelper.add_rates_to_work_packages(@work_packages, @rates)
          @full_services = FacilitiesManagement::Beta::Supplier::SupplierRatesHelper.work_package_to_services(@services, @work_packages_with_rates)
          setup_checkboxes(supplier_services)
        end

        def update_sublot_data_services_prices
          update_checkboxes
          update_rates
          redirect_to facilities_management_beta_admin_supplier_framework_data_path
        end

        private

        def setup_variance_supplier_data(rate_card)
          supplier_rate_card = rate_card['data'][:Variances].select do |k, v|
            v if k.to_s == @supplier_name
          end
          @variance_supplier_data = supplier_rate_card[@supplier_name.to_sym]
        end

        def update_checkboxes
          # params["checked_services"].each do |service|
          #  p service
          # end
        end

        # rubocop:disable Metrics/AbcSize
        def update_rates
          supplier_data = FacilitiesManagement::Admin::SuppliersAdmin.find(params[:id])['data']
          @supplier_name = supplier_data['supplier_name']
          rate_card = CCS::FM::RateCard.latest
          setup_variance_supplier_data(rate_card)

          @variance_supplier_data['Management Overhead %'.to_sym] = params['rate']['M.140'].to_f
          @variance_supplier_data['Corporate Overhead %'.to_sym] = params['rate']['M.141'].to_f
          @variance_supplier_data['Profit %'.to_sym] = params['rate']['M.142'].to_f
          @variance_supplier_data['London Location Variance Rate (%)'.to_sym] = params['rate']['M.144'].to_f
          @variance_supplier_data['Cleaning Consumables per Building User (£)'.to_sym] = params['rate']['M.146'].to_f
          @variance_supplier_data['TUPE Risk Premium (DA %)'.to_sym] = params['rate']['M.148'].to_f
          @variance_supplier_data['Mobilisation Cost (DA %)'.to_sym] = params['rate']['B.1'].to_f
          rate_card.save
        end
        # rubocop:enable Metrics/AbcSize

        def setup_supplier_data_ratecard
          @supplier_data_ratecard_prices = CCS::FM::RateCard.latest[:data][:Prices].select { |key, _| @supplier_name.include? key.to_s }
          @supplier_data_ratecard_prices.values[0].deep_stringify_keys!

          @supplier_data_ratecard_discounts = CCS::FM::RateCard.latest[:data][:Discounts].select { |key, _| @supplier_name.include? key.to_s }
          @supplier_data_ratecard_discounts.values[0].deep_stringify_keys!
        end

        def setup_checkboxes(supplier_services)
          @supplier_rate_data_checkboxes = {}
          @full_services.each do |service|
            service['work_package'].each do |work_pckg|
              code = work_pckg['code']
              @supplier_rate_data_checkboxes[code] = false
            end
          end

          supplier_services.each do |supplier_service|
            @supplier_rate_data_checkboxes[supplier_service] = true if @supplier_rate_data_checkboxes.key?(supplier_service)
          end
        end
      end
    end
  end
end
