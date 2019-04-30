# frozen_string_literal: true

module Postcode
  # post code retrieval
  class PostcodeChecker
    def self.in_london?(postcode)
      info = location_info(postcode)
      @london_burroughs.include? info[0]['administrative_area']
    end

    # SELECT * FROM os_address_view where postcode='G32 0RP';
    def self.location_info(postcode)
      query = "select distinct initcap(add1) as add1, initcap(village) as village, initcap(post_town) as post_town, initcap(county) as county, upper(postcode) as postcode, administrative_area
 from public.os_address_view where postcode = '" + postcode + "';"
      ActiveRecord::Base.connection_pool.with_connection { |db| db.exec_query query }
    end

    @london_burroughs = [
      'CITY OF LONDON', 'BARKING AND DAGENHAM', 'BARNET', 'BEXLEY', 'BRENT',
      'BROMLEY', 'CAMDEN', 'CROYDON', 'EALING', 'ENFIELD', 'GREENWICH',
      'HACKNEY', 'HAMMERSMITH AND FULHAM', 'HARINGEY', 'HARROW', 'HAVERING',
      'HILLINGDON', 'HOUNSLOW', 'ISLINGTON', 'KENSINGTON AND CHELSEA',
      'KINGSTON UPON THAMES', 'LAMBETH', 'LEWISHAM', 'MERTON',
      'NEWHAM', 'REDBRIDGE', 'RICHMOND UPON THAMES', 'SOUTHWARK', 'SUTTON',
      'TOWER HAMLETS', 'WALTHAM FOREST', 'WANDSWORTH', 'CITY OF WESTMINSTER'
    ]
  end
end
