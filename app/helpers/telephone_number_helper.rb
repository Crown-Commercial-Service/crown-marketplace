module TelephoneNumberHelper
  def format_telephone_number(raw)
    country = Phonejack.detect_country(raw) || 'GB'
    ph = Phonejack.parse(raw, country)
    return raw unless ph.valid?

    ph.country.country_id == 'GB' ? ph.national_number : ph.international_number
  end
end
