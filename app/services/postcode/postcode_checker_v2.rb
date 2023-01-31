# frozen_string_literal: true

module Postcode
  # post code retrieval
  class PostcodeCheckerV2
    def self.destructure_postcode(postcode)
      result = { valid: false, input: normalise_postcode(postcode) }
      input  = normalise_postcode(postcode).to_s.strip
      matches = input.match(/^(([A-Z][A-Z]{0,1})([0-9][A-Z0-9]{0,1})) {0,}(([0-9])([A-Z]{2}))$/i)
      unless matches.nil?
        result = {
          valid: true,
          full_postcode: "#{matches[1]} #{matches[4]}",
          postcode_area: matches[2],
          out_code: matches[1],
          postcode_district: matches[1],
          in_code: matches[4],
          larger_in_code: matches[4][0..],
          postcode_sector: matches[5],
          unit_postcode: matches[6]
        }
      end

      result
    end

    def self.location_info(postcode)
      postcode_structure = destructure_postcode(postcode)
      query = <<~HEREDOC
         SELECT distinct summary_line,
           COALESCE (address_line_1, '') as address_line_1,
           COALESCE (address_line_2, '') as address_line_2,
           address_postcode,
           address_town,
           COALESCE ( address_region, '') as address_region,
           COALESCE ( address_region_code, '') as address_region_code
        FROM public.postcode_lookup
         WHERE  address_postcode = '#{postcode_structure[:valid] ? postcode_structure[:full_postcode] : '--'}'
         ORDER BY summary_line;
      HEREDOC
      # in ('N12 9RF', 'AB11 5PN', 'AB11 5PL', 'AB12 4SB', 'AB12 3LF', 'AB10 6PP', 'AB10 1QS', 'NE6 1LA', 'SW1X 9AE', 'MK41 0RU', 'NN8 4PW');
      # where postcode = '#{postcode}'
      ActiveRecord::Base.connection_pool.with_connection { |db| db.exec_query(ActiveRecord::Base.sanitize_sql(query)) }
    rescue StandardError => e
      raise e
    end

    EXCLUDED_POSTCODE_AREAS = %w[GY IM JE].freeze

    def self.find_region(postcode)
      postcode_structure = destructure_postcode(postcode)

      if postcode_structure[:valid] && !EXCLUDED_POSTCODE_AREAS.include?(postcode_structure[:postcode_area])
        result = extract_regions(postcode_structure)

        if result.empty?
          regions_from_nuts
        else
          result
        end
      else
        execute_find_region_query(':')
      end
    rescue StandardError => e
      raise e
    end

    def self.regions_from_nuts
      nuts1region_codes = Nuts1Region.all.map(&:code)
      FacilitiesManagement::Region.all.map { |f| { code: f.code, region: f.name } if f.code.start_with?(*nuts1region_codes) }.compact
    end

    def self.extract_regions(postcode_structure)
      result = process_result(execute_find_region_query(postcode_structure[:full_postcode].delete(' ')))
      return result if result.length == 1

      process_result(execute_find_region_query(postcode_structure[:out_code]))
    end

    def self.process_result(result)
      result.map { |code| code.transform_keys(&:to_sym) }.reject { |region| region[:code].nil? || region[:region].nil? }
    end

    def self.execute_find_region_query(postcode)
      query = <<~HEREDOC
        SELECT DISTINCT PUBLIC.postcodes_nuts_regions.code,
                        PUBLIC.nuts_regions.NAME AS region
        FROM   PUBLIC.postcodes_nuts_regions
               LEFT JOIN PUBLIC.nuts_regions
                      ON PUBLIC.nuts_regions.code = PUBLIC.postcodes_nuts_regions.code
        WHERE  PUBLIC.postcodes_nuts_regions.postcode LIKE '#{normalise_postcode(postcode)}%'
      HEREDOC
      ActiveRecord::Base.connection_pool.with_connection { |db| db.exec_query(ActiveRecord::Base.sanitize_sql(query)) }
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

    def self.normalise_postcode(postcode)
      postcode&.delete(' ')&.upcase
    end
  end
end
