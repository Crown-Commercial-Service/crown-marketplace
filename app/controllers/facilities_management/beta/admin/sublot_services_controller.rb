module FacilitiesManagement
  module Beta
    module Admin
      class SublotServicesController < FacilitiesManagement::Beta::FrameworkController
        rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
        rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
        rescue_from NoMethodError, with: :render_no_method_error_response

        def render_unprocessable_entity_response(exception)
          logger.error exception.message
          redirect_to facilities_management_beta_admin_path, flash: { error: 'Invalid supplier ID lot 1b processing' }
        end

        def render_not_found_response(exception)
          logger.error exception.message
          redirect_to facilities_management_beta_admin_path, flash: { error: 'Invalid supplier ID lot 1b not found' }
        end

        def render_no_method_error_response(exception)
          logger.error exception.message
          redirect_to facilities_management_beta_admin_path, flash: { error: 'Invalid supplier ID lotb method not found' }
        end

        def index
          supplier_data = FacilitiesManagement::Admin::SuppliersAdmin.find(params[:id])['data']
          @supplier_name = supplier_data['supplier_name']

          lot1b_data = supplier_data['lots'].select { |data| data['lot_number'] == '1b' }
          supplier_services = lot1b_data[0]['services']

          rates = FacilitiesManagement::Admin::Rates.all
          services = FacilitiesManagement::Admin::StaticDataAdmin.services
          work_packages = FacilitiesManagement::Admin::StaticDataAdmin.work_packages
          work_packages_with_rates = FacilitiesManagement::Beta::Supplier::SupplierRatesHelper.add_rates_to_work_packages(work_packages, rates)
          @full_services = FacilitiesManagement::Beta::Supplier::SupplierRatesHelper.work_package_to_services(services, work_packages_with_rates)
          setup_checkboxes(supplier_services)
        end

        private

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
