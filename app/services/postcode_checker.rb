# frozen_string_literal: true

# post code retrieval
class PostcodeChecker
  def self.in_london?(postcode)
    info = location_info(postcode)
    false unless info.include?'admin_district'
    @london_burroughs.include? info['admin_district']
  end

  def self.location_info(postcode)
    return @cache[postcode] if @cache.include? postcode

    pc = CGI.escape(postcode)
    uri = URI.parse('http://api.postcodes.io/postcodes/' + pc)
    response = Net::HTTP.get_response(uri)
    j = JSON.parse(response.body)

    return @cache[postcode] = j['result'] if j.include? 'result'

    @cache[postcode] = j
  end

  # @cache = {  }
  # populate postcode with 3 test data entries
  @cache = {
    'SW1P 2BA' =>
    { 'postcode' => 'SW1P 2BA',
      'quality' => 1,
      'eastings' => 529_827,
      'northings' => 179_059,
      'country' => 'England',
      'nhs_ha' => 'London',
      'longitude' => -0.131191,
      'latitude' => 51.495574,
      'european_electoral_region' => 'London',
      'primary_care_trust' => 'Westminster',
      'region' => 'London',
      'lsoa' => 'Westminster 020C',
      'msoa' => 'Westminster 020',
      'incode' => '2BA', 'outcode' => 'SW1P',
      'parliamentary_constituency' => 'Cities of London and Westminster',
      'admin_district' => 'Westminster',
      'parish' => 'Westminster, unparished area',
      'admin_ward' => "St James's",
      'ccg' => 'NHS Central London (Westminster)',
      'nuts' => 'Westminster',
      'codes' => { 'admin_district' => 'E09000033',
                   'admin_county' => 'E99999999',
                   'admin_ward' => 'E05000644',
                   'parish' => 'E43000236',
                   'parliamentary_constituency' => 'E14000639',
                   'ccg' => 'E38000031',
                   'ced' => 'E99999999',
                   'nuts' => 'UKI32' } },
    'G32 0RP' => {
      'postcode' => 'G32 0RP',
      'quality' => 1,
      'eastings' => 266_293,
      'northings' => 663_408,
      'country' => 'Scotland',
      'nhs_ha' => 'Greater Glasgow and Clyde',
      'longitude' => -4.137015,
      'latitude' => 55.845292,
      'european_electoral_region' => 'Scotland',
      'primary_care_trust' => 'Glasgow City Community Health Partnership',
      'lsoa' => 'Mount Vernon North and Sandyhills - 02',
      'msoa' => 'Mount Vernon North and Sandyhills',
      'incode' => '0RP', 'outcode' => 'G32',
      'parliamentary_constituency' => 'Glasgow East',
      'admin_district' => 'Glasgow City',
      'admin_ward' => 'Shettleston',
      'ccg' => 'Glasgow City Community Health Partnership',
      'nuts' => 'Glasgow City',
      'codes' =>
      {
        'admin_district' => 'S12000046',
        'admin_county' => 'S99999999',
        'admin_ward' => 'S13002985',
        'parish' => 'S99999999',
        'parliamentary_constituency' => 'S14000030',
        'ccg' => 'S03000043',
        'ced' => 'S99999999',
        'nuts' => 'UKM82'
      }
    },
    'X11 1XX' => {
      'status' => 404,
      'error' => 'Postcode not found'
    }
  }

  @london_burroughs = [
    'City of London', 'Barking and Dagenham',
    'Barnet', 'Bexley', 'Brent', 'Bromley',
    'Camden', 'Croydon', 'Ealing', 'Enfield',
    'Greenwich', 'Hackney',
    'Hammersmith and Fulham', 'Haringey',
    'Harrow', 'Havering', 'Hillingdon',
    'Hounslow', 'Islington', 'Kensington and Chelsea',
    'Kingston upon Thames', 'Lambeth',
    'Lewisham', 'Merton',
    'Newham', 'Redbridge', 'Richmond upon Thames',
    'Southwark', 'Sutton',
    'Tower Hamlets', 'Waltham Forest',
    'Wandsworth', 'Westminster'
  ]
end
