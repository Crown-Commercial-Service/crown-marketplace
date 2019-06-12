class DirectAward
  def initialize(building_type, service_standard, priced_at_framework, assessed_value)
    @building_type = building_type
    @service_standard = service_standard
    @priced_at_framework = priced_at_framework
    @assessed_value = assessed_value
    Rails.logger.info @building_type + ' ' + @service_standard + ' ' + @priced_at_framework + ' ' + @assessed_value
  end

  def calculate
    eligible = false
    eligible = true if @building_type == 'STANDARD' && @service_standard == 'A' && @priced_at_framework.to_s == 'true' && Integer(@assessed_value) <= 1500000
    Rails.logger.info eligible
    eligible
  end
end
