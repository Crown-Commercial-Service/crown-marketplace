module LegalServices::SuppliersHelper
  def full_lot_description(lot_number, description)
    "Lot #{lot_number} - #{description}"
  end

  def url_formatter(url)
    u = URI.parse(url)

    return url if %w[http https].include?(u.scheme)

    "http://#{url}"
  end
end
