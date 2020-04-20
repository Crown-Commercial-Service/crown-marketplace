# frozen_string_literal: true

module Postcode
  # post code retrieval
  # rubocop:disable Naming/ClassAndModuleCamelCase
  class PostcodeChecker_V2
    def self.location_info(postcode)
      query = <<~HEREDOC
         SELECT summary_line,
           address_line_1,
           address_line_2,
           address_postcode,
           address_town,
           address_region,
           address_region_code
        FROM public.postcode_lookup
         WHERE  address_postcode = '#{postcode}'
         ORDER BY summary_line;
      HEREDOC
      # in ('N12 9RF', 'AB11 5PN', 'AB11 5PL', 'AB12 4SB', 'AB12 3LF', 'AB10 6PP', 'AB10 1QS', 'NE6 1LA', 'SW1X 9AE', 'MK41 0RU', 'NN8 4PW');
      # where postcode = '#{postcode}'
      ActiveRecord::Base.connection_pool.with_connection { |db| db.exec_query query }
    rescue StandardError => e
      raise e
    end

    def self.find_region(postcode)
      query = <<~HEREDOC
        SELECT DISTINCT PUBLIC.postcodes_nuts_regions.code,
                        initcap(PUBLIC.nuts_regions.NAME) AS region
        FROM   PUBLIC.postcodes_nuts_regions
               LEFT JOIN PUBLIC.nuts_regions
                      ON PUBLIC.nuts_regions.code = PUBLIC.postcodes_nuts_regions.code
        WHERE  PUBLIC.postcodes_nuts_regions.postcode LIKE '#{postcode.replace(' ', '').upcase}%'
      HEREDOC
      ActiveRecord::Base.connection_pool.with_connection { |db| db.exec_query query }
    rescue StandardError => e
      raise e
    end

    # SELECT EXISTS (SELECT relname FROM pg_class WHERE relname = 'os_address');
    def self.table_exists
      ActiveRecord::Base.connection_pool.with_connection do |db|
        result = db.exec_query "SELECT EXISTS (SELECT relname FROM pg_class WHERE relname = 'os_address');"
        return 0 if result.nil?

        result[0]['exists']
      end
    rescue StandardError => e
      raise e
    end

    # SELECT COUNT (*) FROM os_address;
    def self.count
      ActiveRecord::Base.connection_pool.with_connection do |db|
        result = db.exec_query "SELECT reltuples AS approximate_row_count FROM pg_class WHERE relname = 'os_address';"
        return 0 if result.nil?

        result.rows[0][0].to_i
      end
    end

    def self.clear
      ActiveRecord::Base.connection_pool.with_connection do |db|
        db.exec_query 'TRUNCATE os_address CASCADE;'
      end
    end

    LONDON_BOROUGHS = ['CITY OF LONDON', 'BARKING AND DAGENHAM', 'BARNET', 'BEXLEY', 'BRENT',
                       'BROMLEY', 'CAMDEN', 'CROYDON', 'EALING', 'ENFIELD', 'GREENWICH',
                       'HACKNEY', 'HAMMERSMITH AND FULHAM', 'HARINGEY', 'HARROW', 'HAVERING',
                       'HILLINGDON', 'HOUNSLOW', 'ISLINGTON', 'KENSINGTON AND CHELSEA',
                       'KINGSTON UPON THAMES', 'LAMBETH', 'LEWISHAM', 'MERTON',
                       'NEWHAM', 'REDBRIDGE', 'RICHMOND UPON THAMES', 'SOUTHWARK', 'SUTTON',
                       'TOWER HAMLETS', 'WALTHAM FOREST', 'WANDSWORTH', 'CITY OF WESTMINSTER'].freeze

    def self.upload(access_key, secret_access_key, bucket, region)
      uploader(access_key, secret_access_key, bucket, region)
    end
  end
  # rubocop:enable Naming/ClassAndModuleCamelCase
end
