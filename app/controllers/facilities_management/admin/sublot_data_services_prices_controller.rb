module FacilitiesManagement
  module Admin
    class SublotDataServicesPricesController < FacilitiesManagement::FrameworkController
      rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
      rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
      rescue_from NoMethodError, with: :render_no_method_error_response

      def render_unprocessable_entity_response(exception)
        logger.error exception.message
        redirect_to facilities_management_admin_path, flash: { error: 'Invalid supplier ID lot 1a processing' }
      end

      def render_not_found_response(exception)
        logger.error exception.message
        redirect_to facilities_management_admin_path, flash: { error: 'Invalid supplier ID lot 1a not found' }
      end

      def render_no_method_error_response(exception)
        logger.error exception.message
        redirect_to facilities_management_admin_path, flash: { error: 'Invalid supplier ID lot 1a method not found' }
      end

      def index
        @list_service_types = ['Direct Award Discount (%)', 'General office - Customer Facing (£)', 'General office - Non Customer Facing (£)', 'Call Centre Operations (£)', 'Warehouses (£)', 'Restaurant and Catering Facilities (£)', 'Pre-School (£)', 'Primary School (£)', 'Secondary Schools (£)', 'Special Schools (£)', 'Universities and Colleges (£)', 'Community - Doctors, Dentist, Health Clinic (£)', 'Nursing and Care Homes (£)']
        @variance_names = ['td_overhead_html', 'td_corporate', 'td_profit', 'td_london', 'td_cleaning_html', 'td_tupe', 'td_mobilisation']
        @variance_values = ['Management Overhead %', 'Corporate Overhead %', 'Profit %', 'London Location Variance Rate (%)', 'Cleaning Consumables per Building User (£)', 'TUPE Risk Premium (DA %)', 'Mobilisation Cost (DA %)']
        @variances = ['M.140', 'M.141', 'M.142', 'M.144', 'M.146', 'M.148', 'B.1']
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
          redirect_to facilities_management_admin_get_sublot_data_path(params[:id]), flash: { error: error_services }
        else
          update_data_table(false)
          update_checkboxes
          update_rates(false)
          redirect_to facilities_management_admin_supplier_framework_data_path
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
        @work_packages_with_rates = FacilitiesManagement::Supplier::SupplierRatesHelper.add_rates_to_work_packages(@work_packages, @rates)
        @full_services = FacilitiesManagement::Supplier::SupplierRatesHelper.work_package_to_services(@services, @work_packages_with_rates)
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

      def update_rates(only_validate)
        invalid_services = []
        supplier_data = FacilitiesManagement::Admin::SuppliersAdmin.find(params[:id])['data']
        @supplier_name = supplier_data['supplier_name']
        rate_card = CCS::FM::RateCard.latest
        setup_variance_supplier_data(rate_card)

        if only_validate
          update_rates_invalid_services(invalid_services)
        else
          codes = ['M.140', 'M.141', 'M.142', 'M.144', 'M.146', 'M.148', 'B.1']
          names = ['Management Overhead %', 'Corporate Overhead %', 'Profit %', 'London Location Variance Rate (%)', 'Cleaning Consumables per Building User (£)', 'TUPE Risk Premium (DA %)', 'Mobilisation Cost (DA %)']
          codes.each.with_index do |code, i|
            @variance_supplier_data[names[i].to_sym] = params['rate'][code].to_f
          end

          rate_card.save
        end
        invalid_services
      end

      # rubocop:disable Metrics/AbcSize
      def update_rates_invalid_services(invalid_services)
        # Note: I add the service name to the flash error ,and the value the user entered in the next array index
        ['M.140', 'M.141', 'M.142', 'M.144', 'M.148', 'B.1'].each do |code|
          unless numeric?(params['rate'][code]) && value_in_range?(params['rate'][code])
            invalid_services << code
            invalid_services << params['rate'][code]
          end
        end

        invalid_services << 'M.146' unless numeric?(params['rate']['M.146']) && !more_than_max_decimals?(params['rate']['M.146'])
        invalid_services << params['rate']['M.146'] unless numeric?(params['rate']['M.146']) & !more_than_max_decimals?(params['rate']['M.146'])
      end
      # rubocop:enable Metrics/AbcSize

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
              range_result = if service_type_key.include?('%') && numeric_result
                               value_in_range?(params['data'][service_key][service_type_key])
                             else
                               true
                             end
              invalid_services << service_key unless numeric_result && range_result
              invalid_services << service_key + service_type_key unless numeric_result && range_result
              invalid_services << params['data'][service_key][service_type_key] unless numeric_result && range_result
            elsif key == 'Direct Award Discount'
              new_value = params['data'][service_key][service_type_key]
              new_value = new_value.to_f unless new_value.empty?
              @supplier_data_ratecard_discounts.values[0][service_key]['Disc %'] = new_value unless @supplier_data_ratecard_discounts.values[0][service_key].nil?
            else
              new_value = params['data'][service_key][service_type_key]
              new_value = new_value.to_f unless new_value.empty?
              @supplier_data_ratecard_prices.values[0][service_key][key] = new_value unless @supplier_data_ratecard_prices.values[0][service_key].nil?
            end
          end
        end
        latest_rate_card.save unless only_validate
        invalid_services
      end
      # rubocop:enable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity

      def numeric?(user_entered_value)
        return true if user_entered_value.nil? || user_entered_value.blank?

        user_entered_value.match(/\A[+]?\d+?(_?\d+)*(\.\d+e?\d*)?\Z/) != nil
      end

      def value_in_range?(user_entered_value)
        return true if user_entered_value.nil? || user_entered_value.blank?

        return false if more_than_max_decimals?(user_entered_value)

        user_entered_value.to_f <= 100
      end

      def more_than_max_decimals?(user_entered_value)
        return false if user_entered_value.nil? || user_entered_value.blank?

        (BigDecimal(user_entered_value) - BigDecimal(user_entered_value).floor).to_s.size - 2 > 20
      end
    end
  end
end
