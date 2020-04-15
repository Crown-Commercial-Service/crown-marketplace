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
          redirect_to facilities_management_beta_admin_path, flash: { error: 'Invalid supplier ID lot 1a method not found' }
        end

        def index
          @list_service_types = ['Direct Award Discount (%)', 'General office - Customer Facing (£)', 'General office - Non Customer Facing (£)', 'Call Centre Operations (£)', 'Warehouses (£)', 'Restaurant and Catering Facilities (£)', 'Pre-School (£)', 'Primary School (£)', 'Secondary Schools (£)', 'Special Schools (£)', 'Universities and Colleges (£)', 'Community - Doctors, Dentist, Health Clinic (£)', 'Nursing and Care Homes (£)']
          supplier_services = setup_supplier_data
          setup_supplier_data_ratecard
          setup_variance_supplier_data(CCS::FM::RateCard.latest)
          setup_instance_variables
          setup_checkboxes(supplier_services)
        end

        def update_sublot_data_services_prices
          setup_supplier_data
          setup_instance_variables

          error_services = update_data_table(true)
          error_services += update_rates(true)

          if !error_services.empty?
            redirect_to facilities_management_beta_admin_get_sublot_data_path(params[:id]), flash: { error: error_services }
          else
            update_data_table(false)
            update_checkboxes
            update_rates(false)
            redirect_to facilities_management_beta_admin_supplier_framework_data_path
          end
        end

        private

        def setup_supplier_data
          supplier_data = FacilitiesManagement::Admin::SuppliersAdmin.find(params[:id])['data']
          @supplier_name = supplier_data['supplier_name']

          lot1a_data = supplier_data['lots'].select { |data| data['lot_number'] == '1a' }
          lot1a_data[0]['services']
        end

        def setup_instance_variables
          @services = FacilitiesManagement::Admin::StaticDataAdmin.services
          @work_packages = FacilitiesManagement::Admin::StaticDataAdmin.work_packages
          @rates = FacilitiesManagement::Admin::Rates.all
          @work_packages_with_rates = FacilitiesManagement::Beta::Supplier::SupplierRatesHelper.add_rates_to_work_packages(@work_packages, @rates)
          @full_services = FacilitiesManagement::Beta::Supplier::SupplierRatesHelper.work_package_to_services(@services, @work_packages_with_rates)
        end

        def setup_variance_supplier_data(rate_card)
          supplier_rate_card = rate_card['data'][:Variances].select do |k, v|
            v if k.to_s == @supplier_name
          end
          @variance_supplier_data = supplier_rate_card[@supplier_name.to_sym]
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

        # rubocop:disable Metrics/AbcSize
        def update_checkboxes
          supplier = FacilitiesManagement::Admin::SuppliersAdmin.find(params[:id])
          supplier_data = supplier['data']
          @supplier_name = supplier_data['supplier_name']

          lot1a_data = supplier_data['lots'].select { |data| data['lot_number'] == '1a' }
          supplier_services = lot1a_data[0]['services']

          supplier_checkboxes = determine_used_services
          supplier_checkboxes.each do |service|
            supplier_services.append(service) if (params['checked_services'].include? service) && (!supplier_services.include? service)
            supplier_services.delete(service) if (!params['checked_services'].include? service) && (supplier_services.include? service)
          end

          supplier.save
        end
        # rubocop:enable Metrics/AbcSize

        def determine_used_services
          supplier_checkboxes = []
          @full_services.each do |service|
            service['work_package'].each do |work_pckg|
              code = work_pckg['code']
              supplier_checkboxes.append(code)
            end
          end
          supplier_checkboxes
        end

        # rubocop:disable Metrics/AbcSize
        def update_rates(only_validate)
          invalid_services = []
          supplier_data = FacilitiesManagement::Admin::SuppliersAdmin.find(params[:id])['data']
          @supplier_name = supplier_data['supplier_name']
          rate_card = CCS::FM::RateCard.latest
          setup_variance_supplier_data(rate_card)

          if only_validate
            update_rates_invalid_services(invalid_services)
          else
            @variance_supplier_data['Management Overhead %'.to_sym] = params['rate']['M.140'].to_f
            @variance_supplier_data['Corporate Overhead %'.to_sym] = params['rate']['M.141'].to_f
            @variance_supplier_data['Profit %'.to_sym] = params['rate']['M.142'].to_f
            @variance_supplier_data['London Location Variance Rate (%)'.to_sym] = params['rate']['M.144'].to_f
            @variance_supplier_data['Cleaning Consumables per Building User (£)'.to_sym] = params['rate']['M.146'].to_f
            @variance_supplier_data['TUPE Risk Premium (DA %)'.to_sym] = params['rate']['M.148'].to_f
            @variance_supplier_data['Mobilisation Cost (DA %)'.to_sym] = params['rate']['B.1'].to_f
            rate_card.save
          end
          invalid_services
        end
        # rubocop:enable Metrics/AbcSize

        # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/AbcSize
        def update_rates_invalid_services(invalid_services)
          # Note: I add the service name to the flash error ,and the value the user entered in the next array index
          invalid_services << 'M.140' unless numeric?(params['rate']['M.140'])
          invalid_services << params['rate']['M.140'] unless numeric?(params['rate']['M.140'])

          invalid_services << 'M.141' unless numeric?(params['rate']['M.141'])
          invalid_services << params['rate']['M.141'] unless numeric?(params['rate']['M.141'])

          invalid_services << 'M.142' unless numeric?(params['rate']['M.142'])
          invalid_services << params['rate']['M.142'] unless numeric?(params['rate']['M.142'])

          invalid_services << 'M.144' unless numeric?(params['rate']['M.144'])
          invalid_services << params['rate']['M.144'] unless numeric?(params['rate']['M.144'])

          invalid_services << 'M.146' unless numeric?(params['rate']['M.146'])
          invalid_services << params['rate']['M.146'] unless numeric?(params['rate']['M.146'])

          invalid_services << 'M.148' unless numeric?(params['rate']['M.148'])
          invalid_services << params['rate']['M.148'] unless numeric?(params['rate']['M.148'])

          invalid_services << 'B.1' unless numeric?(params['rate']['B.1'])
          invalid_services << params['rate']['B.1'] unless numeric?(params['rate']['B.1'])
        end
        # rubocop:enable Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity, Metrics/AbcSize

        def setup_supplier_data_ratecard
          latest_rate_card = CCS::FM::RateCard.latest
          @supplier_data_ratecard_prices = latest_rate_card[:data][:Prices].select { |key, _| @supplier_name.include? key.to_s }
          @supplier_data_ratecard_prices.values[0].deep_stringify_keys!

          @supplier_data_ratecard_discounts = latest_rate_card[:data][:Discounts].select { |key, _| @supplier_name.include? key.to_s }
          @supplier_data_ratecard_discounts.values[0].deep_stringify_keys!
          latest_rate_card
        end

        # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
        def update_data_table(only_validate)
          invalid_services = []
          latest_rate_card = setup_supplier_data_ratecard

          # Note for an error to make it easier to display in the front end:
          # I add the service name to the flash error ,
          # then the service+service_type on the next position
          # and the value the user entered in the next array index

          params['data'].each do |service_key, service|
            service.each do |service_type_key, _|
              key = service_type_key.remove(' (%)').remove(' (£)')

              if only_validate
                numeric_result = numeric?(params['data'][service_key][service_type_key])
                invalid_services << service_key unless numeric_result
                invalid_services << service_key + service_type_key unless numeric_result
                invalid_services << params['data'][service_key][service_type_key] unless numeric_result
              elsif key == 'Direct Award Discount'
                @supplier_data_ratecard_discounts.values[0][service_key]['Disc %'] = params['data'][service_key][service_type_key].to_f unless @supplier_data_ratecard_discounts.values[0][service_key].nil?
              else
                @supplier_data_ratecard_prices.values[0][service_key][key] = params['data'][service_key][service_type_key].to_f unless @supplier_data_ratecard_prices.values[0][service_key].nil?
              end
            end
          end
          latest_rate_card.save unless only_validate
          invalid_services
        end
        # rubocop:enable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity

        # rubocop:disable Style/MultipleComparison
        def numeric?(user_entered_value)
          return true if user_entered_value.nil? || user_entered_value.blank?

          user_entered_value.to_i.to_s == user_entered_value || user_entered_value.to_f.to_s == user_entered_value
        end
        # rubocop:enable Style/MultipleComparison
      end
    end
  end
end
