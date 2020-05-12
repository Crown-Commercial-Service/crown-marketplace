module BuildingsControllerRegions
  extend ActiveSupport::Concern

  def ensure_postcode_is_valid(postcode)
    if [' '].exclude?(postcode)
      postcode_reg = /^(([A-Z][A-Z]{0,1})([0-9][A-Z0-9]{0,1})) {0,}(([0-9])([A-Z]{2}))$/i
      matches = postcode.match(postcode_reg)
      return "#{matches[1]} #{matches[4]}"
    end
    postcode
  end

  def find_addresses_by_postcode(postcode)
    postcode = ensure_postcode_is_valid(postcode)
    Rails.logger.info "Postcode lookup: #{postcode}"
    Postcode::PostcodeChecker_V2.location_info(postcode)
  rescue StandardError => e
    Rails.logger.error("Postcode lookup error:\n#{e.message}")
    []
  end

  def find_region_query_by_postcode(postcode)
    result = get_region_postcode(postcode).to_a.map { |r| r.to_h.deep_symbolize_keys }
    if result.length.positive?
    else
      result = get_region_by_prefix(postcode).to_a.map { |r| r.to_h.deep_symbolize_keys }
    end
    result = Nuts3Region.all.map { |f| { code: f.code, region: f.name } } if result.length.zero?

    result
  rescue StandardError => e
    Rails.logger.error("Region lookup error:\n#{e.message}")
    []
  end

  def get_region_by_prefix(postcode)
    Postcode::PostcodeChecker.find_region postcode[0, 3].delete(' ')
  end

  def get_region_postcode(postcode)
    Postcode::PostcodeChecker.find_region postcode.delete(' ')
  end
end
