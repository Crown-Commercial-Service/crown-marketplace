# frozen_string_literal: true

module Postcode
  # post code retrieval
  class PostcodeChecker
    def self.in_london?(postcode)
      info = location_info(postcode)

      { status: 200, result: (@london_burroughs.include? info[0]['administrative_area']) }

    rescue StandardError
      false
    end

    # SELECT * FROM os_address where postcode='G32 0RP';
    def self.location_info(postcode)
      query = 'SELECT * FROM os_address where postcode=\'' + postcode + '\';'
      res = ActiveRecord::Base.connection_pool.with_connection { |db| db.exec_query query }
      { status: 200, result: res }
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
