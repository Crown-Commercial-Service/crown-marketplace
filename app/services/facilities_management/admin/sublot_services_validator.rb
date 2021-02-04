class FacilitiesManagement::Admin::SublotServicesValidator
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
      service.each do |service_type_key, _|
        numeric_result_valid = numeric?(@data[service_key][service_type_key])
        range_result_valid = if service_type_key.include?('%') && numeric_result_valid
                               value_in_range?(@data[service_key][service_type_key])
                             else
                               true
                             end

        next if numeric_result_valid && range_result_valid

        @invalid_services[service_key] = {} unless @invalid_services.keys.include? service_key
        @invalid_services[service_key][service_type_key] = @data[service_key][service_type_key]
      end
    end
  end

  def validate_rates
    ['M.140', 'M.141', 'M.142', 'M.144', 'M.148', 'B.1'].each do |code|
      next if numeric?(@rates[code]) && value_in_range?(@rates[code])

      @invalid_services[code] = @rates[code]
    end

    return if numeric?(@rates['M.146']) && !more_than_max_decimals?(@rates['M.146'])

    @invalid_services['M.146'] = @rates['M.146']
  end

  def update_data
    @data.each do |service_key, service|
      service.each do |service_type_key, _|
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

  def numeric?(user_entered_value)
    return true if user_entered_value.blank?

    user_entered_value.match(/\A[+]?\d+?(_?\d+)*(\.\d+e?\d*)?\Z/) != nil
  end

  def value_in_range?(user_entered_value)
    return true if user_entered_value.blank?

    return false if more_than_max_decimals?(user_entered_value)

    user_entered_value.to_f <= 100
  end

  def more_than_max_decimals?(user_entered_value)
    return false if user_entered_value.blank?

    (BigDecimal(user_entered_value) - BigDecimal(user_entered_value).floor).to_s.size - 2 > 20
  end
end
