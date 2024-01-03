module FacilitiesManagement::RM3830
  module Admin
    class FilesImporter::DataChecker < FacilitiesManagement::FilesImporter::DataChecker
      private

      def check_processed_data
        supplier_errors = {}
        supplier_errors['prices'] = validate_data('Prices', ['General office - Customer Facing', 'General office - Non Customer Facing', 'Call Centre Operations', 'Warehouses', 'Restaurant and Catering Facilities', 'Pre-School', 'Primary School', 'Secondary Schools', 'Special Schools', 'Universities and Colleges', 'Community - Doctors, Dentist, Health Clinic', 'Nursing and Care Homes'])
        supplier_errors['discounts'] = validate_data('Discounts', ['Disc %'])
        supplier_errors['variances'] = validate_variance_data

        return if supplier_errors.all? { |_, errors| errors.empty? }

        supplier_errors.each do |rate_type, errors|
          errors.each do |error_type, error_details|
            @errors << { error: "#{rate_type}_#{error_type}", details: error_details }
          end
        end
      end

      def validate_data(key, rate_types)
        validate_each(key) do |supplier, supplier_rates, supplier_errors|
          supplier_rates.each do |code, rate|
            rate_types.each do |type|
              required_validation = validation_type(key, code)
              validation = RateValidator.new(rate[type].to_s, required_validation == :full_range)

              next if validation.valid?(required_validation)

              supplier_errors[validation.error_type] ||= []
              supplier_errors[validation.error_type] << supplier
            end
          end
        end
      end

      def validate_variance_data
        validate_each('Variances') do |supplier, supplier_variances, supplier_errors|
          next if supplier_variances.empty?

          ['Management Overhead %', 'Corporate Overhead %', 'Profit %', 'London Location Variance Rate (%)', 'Cleaning Consumables per Building User (£)', 'TUPE Risk Premium (DA %)', 'Mobilisation Cost (DA %)'].each do |type|
            required_validation = validation_type('Variances', type)
            variance_validation = RateValidator.new(supplier_variances[type].to_s, required_validation == :full_range)

            next if variance_validation.valid?(required_validation)

            supplier_errors[variance_validation.error_type] ||= []
            supplier_errors[variance_validation.error_type] << supplier
          end
        end
      end

      def validate_each(key)
        supplier_errors = {}

        @supplier_data[key].each do |supplier, supplier_rates|
          yield(supplier, supplier_rates, supplier_errors)
        end

        supplier_errors.each_value(&:uniq!)
      end

      def validation_type(key, code)
        case key
        when 'Prices'
          :full_range if ['M.1', 'N.1'].include?(code)
        when 'Discounts'
          :full_range
        when 'Variances'
          :full_range unless code == 'Cleaning Consumables per Building User (£)'
        end
      end
    end
  end
end
