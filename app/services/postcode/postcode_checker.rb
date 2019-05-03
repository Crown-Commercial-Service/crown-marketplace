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
    def self.count(access_key, secret_access_key)
      'invalid access key or secret key' unless verify_access(access_key, secret_access_key)

      ActiveRecord::Base.connection_pool.with_connection do |db|
        result = db.exec_query 'SELECT COUNT (postcode) FROM os_address;'
        return 0 if result.nil?

        result[0]['count']
      end
    rescue StandardError => e
      e
    end

    def self.clear(access_key, secret_access_key)
      'invalid access key or secret key' unless verify_access(access_key, secret_access_key)

      ActiveRecord::Base.connection_pool.with_connection do |db|
        db.exec_query 'DROP VIEW IF EXISTS public.os_address_view;'
        db.exec_query 'DROP TABLE IF EXISTS os_address;'
      end
    rescue StandardError => e
      e
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

    def self.upload(access_key, secret_access_key, bucket, region)
      uploader(access_key, secret_access_key, bucket, region)
    end

    # private class methods
    class << self
      def verify_access(access_key, secret_access_key)
        secrets = JSON.parse(File.read(Rails.root.to_s + '/../aws-secrets.json'))
        access_key == secrets['AccessKeyId'] && secret_access_key == secrets['SecretAccessKey']
      rescue StandardError
        false
      end

      def uploader(access_key, secret_access_key, bucket, region)
        aws_secrets = {
          AccessKeyId: access_key,
          SecretAccessKey: secret_access_key,
          bucket: bucket,
          region: region
        }

        File.open(Rails.root.to_s + '/../aws-secrets.json', 'w') { |file| file.write(aws_secrets.to_json) }

        rake 'db:postcode'

        { status: 200, result: "Uploading postcodes from AWS bucket #{bucket}, region: #{region}" }
      rescue IOError => e
        # some error occur, dir not writable etc.
        { status: 404, error: e.to_s }
      rescue StandardError => e
        { status: 404, error: e.to_s }
      end

      # rake 'db:postcode'
      def rake(task_name)
        if File.split($PROGRAM_NAME).last == 'rake'
          Rails.logger.info('')
        else
          begin
            Rails.logger.info('No, this is not a Rake task')
            Rails.application.load_tasks
            Rake::Task[task_name].execute
          rescue StandardError => e
            message = self.class.name + " data is missing! Please run 'rake " + task_name + "' to load postcode data."
            Rails.logger.info("\e[5;37;41m\n" + message + '\n' + e.to_s + "\033[0m\n")
            # Rails.logger.info("\e[5;37;41m\n" + e.to_s + "\033[0m\n")
            raise e
          end
        end
      end
    end
  end
end
