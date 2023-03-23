# frozen_string_literal: true

module Postcode
  # post code retrieval
  class PostcodeChecker
    def self.in_london?(postcode)
      info = location_info(postcode)
      @london_burroughs.include? info[0]['county'].upcase
    end

    # SELECT * FROM os_address_view where postcode='G32 0RP';
    def self.location_info(postcode)
      query = <<~HEREDOC
        select  distinct  initcap(add1)  as  add1,  initcap(village) as village,
        initcap(post_town)  as  post_town,
        initcap(county)  as  county,
        upper(public.os_address_view.postcode) as postcode, building_ref,
        public.nuts_regions.name as region,
        public.postcodes_nuts_regions.code as regioncode
        from public.os_address_view
        left join public.postcodes_nuts_regions ON public.postcodes_nuts_regions.postcode = '#{postcode.delete(' ')}'
        left join public.nuts_regions ON public.nuts_regions.code = public.postcodes_nuts_regions.code
        where public.os_address_view.postcode = '#{postcode}'
      HEREDOC
      ActiveRecord::Base.connection_pool.with_connection { |db| db.exec_query query }
    end

    def self.find_region(postcode)
      query = <<~HEREDOC
        select
        distinct public.postcodes_nuts_regions.code,
        initcap(public.nuts_regions.name) as region
        from public.postcodes_nuts_regions
        left join public.nuts_regions ON public.nuts_regions.code = public.postcodes_nuts_regions.code
        where public.postcodes_nuts_regions.postcode like '#{postcode.upcase}%'
      HEREDOC
      ActiveRecord::Base.connection_pool.with_connection { |db| db.exec_query query }
    end

    # SELECT EXISTS (SELECT relname FROM pg_class WHERE relname = 'os_address');
    def self.table_exists
      ActiveRecord::Base.connection_pool.with_connection do |db|
        result = db.exec_query "SELECT EXISTS (SELECT relname FROM pg_class WHERE relname = 'os_address');"
        return 0 if result.nil?

        result[0]['exists']
      end
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

    @london_burroughs = ['CITY OF LONDON', 'BARKING AND DAGENHAM', 'BARNET', 'BEXLEY', 'BRENT',
                         'BROMLEY', 'CAMDEN', 'CROYDON', 'EALING', 'ENFIELD', 'GREENWICH',
                         'HACKNEY', 'HAMMERSMITH AND FULHAM', 'HARINGEY', 'HARROW', 'HAVERING',
                         'HILLINGDON', 'HOUNSLOW', 'ISLINGTON', 'KENSINGTON AND CHELSEA',
                         'KINGSTON UPON THAMES', 'LAMBETH', 'LEWISHAM', 'MERTON',
                         'NEWHAM', 'REDBRIDGE', 'RICHMOND UPON THAMES', 'SOUTHWARK', 'SUTTON',
                         'TOWER HAMLETS', 'WALTHAM FOREST', 'WANDSWORTH', 'CITY OF WESTMINSTER']

    def self.upload(access_key, secret_access_key, bucket, region)
      uploader(access_key, secret_access_key, bucket, region)
    end

    # private class methods
    class << self
      def uploader(access_key, secret_access_key, bucket, region)
        rake 'db:webpostcode', access_key, secret_access_key, bucket, region

        { status: 200, result: "Uploading postcodes from AWS bucket #{bucket}, region: #{region}" }
      end

      # rake 'db:postcode'
      def rake(task_name, access_key, secret_access_key, bucket, region)
        if File.split($PROGRAM_NAME).last == 'rake'
          Rails.logger.info('')
        else
          begin
            Rails.logger.info('No, this is not a Rake task')
            Rails.application.load_tasks
            args = %i[access_key secret_access_key bucket region].zip([access_key, secret_access_key, bucket, region]).to_h
            Rake::Task[task_name].execute(args)
          rescue StandardError => e
            Rails.logger.info("\e[5;37;41m\n#{e}\e[0m\n")
            raise e
          end
        end
      end
    end
  end
end
