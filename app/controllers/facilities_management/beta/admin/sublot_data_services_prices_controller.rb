module FacilitiesManagement
  module Beta
    module Admin
      class SublotDataServicesPricesController < FacilitiesManagement::Beta::FrameworkController
        rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
        rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

        def render_unprocessable_entity_response(exception)
          logger.error exception.message
          redirect_to facilities_management_beta_admin_path, flash: { error: 'Invalid supplier ID processing' }
        end

        def render_not_found_response(exception)
          logger.error exception.message
          redirect_to facilities_management_beta_admin_path, flash: { error: 'Invalid supplier ID not found' }
        end

        def index
          @list_service_types = ['Direct Award Discount (%)', 'General office - Customer Facing (£)', 'General office - Non Customer Facing (£)', 'Call Centre Operations (£)', 'Warehouses (£)', 'Restaurant and Catering Facilities (£)', 'Pre-School (£)', 'Primary School (£)', 'Secondary Schools (£)', 'Special Schools (£)', 'Universities and Colleges (£)', 'Community - Doctors, Dentist, Health Clinic (£)', 'Nursing and Care Homes (£)']

          supplier_data = CCS::FM::Supplier.find(params[:id])['data']
          @supplier_name = supplier_data['supplier_name']
          supplier_services = supplier_data['lots'][0]['services']

          setup_supplier_data_ratecard

          @rates = FacilitiesManagement::Admin::Rates.all
          @services = FacilitiesManagement::Admin::StaticDataAdmin.services
          @work_packages = FacilitiesManagement::Admin::StaticDataAdmin.work_packages
          @work_packages_with_rates = FacilitiesManagement::Beta::Supplier::SupplierRatesHelper.add_rates_to_work_packages(@work_packages, @rates)
          @full_services = FacilitiesManagement::Beta::Supplier::SupplierRatesHelper.work_package_to_services(@services, @work_packages_with_rates)
          setup_checkboxes(supplier_services)
        end

        private

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
