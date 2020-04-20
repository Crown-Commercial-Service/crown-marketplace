module BuildingsControllerRegions
  extend ActiveSupport::Concern

  def find_addresses_by_postcode(postcode)
    Rails.logger.info "Postcode lookup: #{postcode}"
    Postcode::PostcodeChecker_V2.location_info(postcode)

  rescue StandardError => e
    Rails.logger.error("Postcode lookup error:\n#{([e.message]+e.backtrace).join($/)}")
    []
  end

  def find_region_query_by_postcode(postcode)
    result = get_region_postcode postcode
    if result.length.positive?
    else
      result = get_region_by_prefix postcode
    end
    result = Nuts3Region.all.map { |f| { code: f.code, region: f.name } } if result.length.zero?

    result
  rescue StandardError => e
    Rails.logger.error("Region lookup error:\n#{([e.message]+e.backtrace).join($/)}")
    []
  end

  def get_region_by_prefix(postcode)
    Postcode::PostcodeChecker.find_region postcode[0, 3].delete(' ')
  end

  def get_region_postcode(postcode)
    Postcode::PostcodeChecker.find_region postcode.delete(' ')
  end
end
