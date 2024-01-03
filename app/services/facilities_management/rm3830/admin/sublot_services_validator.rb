module FacilitiesManagement::RM3830::Admin
  class SublotServicesValidator
    attr_reader :invalid_services, :supplier_data_ratecard_prices, :supplier_data_ratecard_discounts, :variance_supplier_data

    def initialize(params, latest_rate_card, prices, discounts, variance)
      @data = params['data']
      @rates = params['rate']
      @invalid_services = {}

      @rate_card = latest_rate_card
      @supplier_data_ratecard_prices = prices
      @supplier_data_ratecard_discounts = discounts
      @variance_supplier_data = variance
    end

    def save
      update_data
      update_rates
      return false unless valid?

      @rate_card.save
      true
    end

    private

    def valid?
      validate_data
      validate_rates
      @invalid_services.empty?
    end

    def validate_data
      @data.each do |service_key, service|
        service.each_key do |service_type_key|
          rate_validation = RateValidator.new(@data[service_key][service_type_key])

          next if rate_validation.valid?(rate_validation_type(service_type_key, service_key))

          @invalid_services[service_key] = {} unless @invalid_services.keys.include? service_key
          @invalid_services[service_key][service_type_key] = { value: @data[service_key][service_type_key], error_type: rate_validation.error_type }
        end
      end
    end

    def validate_rates
      ['M.140', 'M.141', 'M.142', 'M.144', 'M.146', 'M.148', 'B.1'].each do |code|
        rate_validation = RateValidator.new(@rates[code])

        next if rate_validation.valid?(variance_validation_type(code))

        @invalid_services[code] = { value: @rates[code], error_type: rate_validation.error_type }
      end
    end

    def update_data
      @data.each do |service_key, service|
        service.each_key do |service_type_key|
          key = service_type_key.remove(' (%)').remove(' (£)')

          new_value = @data[service_key][service_type_key]
          new_value = new_value.to_f if new_value.present?

          if key == 'Direct Award Discount'
            @supplier_data_ratecard_discounts[service_key]['Disc %'] = new_value unless @supplier_data_ratecard_discounts[service_key].nil?
          else
            @supplier_data_ratecard_prices[service_key][key] = new_value unless @supplier_data_ratecard_prices[service_key].nil?
          end
        end
      end
    end

    def update_rates
      codes_and_name = { 'M.140': :'Management Overhead %', 'M.141': :'Corporate Overhead %', 'M.142': :'Profit %', 'M.144': :'London Location Variance Rate (%)', 'M.146': :'Cleaning Consumables per Building User (£)', 'M.148': :'TUPE Risk Premium (DA %)', 'B.1': :'Mobilisation Cost (DA %)' }

      codes_and_name.each do |code, name|
        @variance_supplier_data[name] = @rates[code].to_f
      end
    end

    def rate_validation_type(service_type_key, service_key)
      :full_range if service_type_key.include?('%') || ['M.1', 'N.1'].include?(service_key)
    end

    def variance_validation_type(code)
      :full_range unless code == 'M.146'
    end
  end
end
