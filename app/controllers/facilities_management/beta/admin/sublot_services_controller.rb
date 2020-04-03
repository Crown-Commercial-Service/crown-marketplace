module FacilitiesManagement
  module Beta
    module Admin
      class SublotServicesController < FacilitiesManagement::Beta::FrameworkController
        rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
        rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
        rescue_from NoMethodError, with: :render_no_method_error_response

        def render_unprocessable_entity_response(exception)
          logger.error exception.message
          redirect_to facilities_management_beta_admin_path, flash: { error: 'Invalid supplier ID lot processing' }
        end

        def render_not_found_response(exception)
          logger.error exception.message
          redirect_to facilities_management_beta_admin_path, flash: { error: 'Invalid supplier ID lot not found' }
        end

        def render_no_method_error_response(exception)
          logger.error exception.message
          redirect_to facilities_management_beta_admin_path, flash: { error: 'Invalid supplier ID lot method not found' }
        end

        def index
          supplier_data = FacilitiesManagement::Admin::SuppliersAdmin.find(params[:id])['data']
          @supplier_name = supplier_data['supplier_name']
          @lot_name = 'Sub-lot ' + params[:lot] + ' services'

          lot_data = supplier_data['lots'].select { |data| data['lot_number'] == params[:lot] }
          supplier_services = lot_data[0]['services']

          setup_data
          setup_checkboxes(supplier_services)
        end

        # rubocop:disable Metrics/AbcSize
        def update_sublot_services
          supplier = FacilitiesManagement::Admin::SuppliersAdmin.find(params[:id])
          supplier_data = supplier['data']
          @supplier_name = supplier_data['supplier_name']

          lot_data = supplier_data['lots'].select { |data| data['lot_number'] == params[:lot] }
          supplier_services = lot_data[0]['services']

          setup_data
          supplier_checkboxes = determine_all_used_services
          supplier_checkboxes.each do |service|
            supplier_services.append(service) if (params['checked_services'].include? service) && (!supplier_services.include? service)
            supplier_services.delete(service) if (!params['checked_services'].include? service) && (supplier_services.include? service)
          end

          supplier.save
          redirect_to facilities_management_beta_admin_supplier_framework_data_path
        end
        # rubocop:enable Metrics/AbcSize

        private

        def setup_data
          rates = FacilitiesManagement::Admin::Rates.all
          services = FacilitiesManagement::Admin::StaticDataAdmin.services
          work_packages = FacilitiesManagement::Admin::StaticDataAdmin.work_packages
          work_packages_with_rates = FacilitiesManagement::Beta::Supplier::SupplierRatesHelper.add_rates_to_work_packages(work_packages, rates)
          @full_services = FacilitiesManagement::Beta::Supplier::SupplierRatesHelper.work_package_to_services(services, work_packages_with_rates)
        end

        def determine_all_used_services
          supplier_checkboxes = []
          @full_services.each do |service|
            service['work_package'].each do |work_pckg|
              code = work_pckg['code']
              supplier_checkboxes.append(code)
            end
          end
          supplier_checkboxes
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
