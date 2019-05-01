# frozen_string_literal: true

module Postcode
  # return json
  class PostcodesController < ApplicationController
    protect_from_forgery with: :exception
    require_permission :none, only: :show

    # GET /postcodes/SW1A 2AA
    # GET /postcodes/SW1A 2AA.json
    #
    # usage:
    #      http://localhost:3000/postcodes/SW1A%202AA
    #      http://localhost:3000/postcodes/in_london?postcode=SW1P%202AP
    #      http://localhost:3000/postcodes/in_london?postcode=G69%206HB
    def show
      result = if params[:id] == 'in_london'
                 PostcodeChecker.in_london? params[:postcode]
               elsif params[:id] == 'upload'
                 upload(params[:access_key], params[:secret_access_key], params[:bucket], params[:region])
               else
                 PostcodeChecker.location_info(params[:id])
               end
      render json: { status: 200, result: result }
    rescue StandardError
      render json: { status: 404, error: 'Postcode not found' }
    end

    private

    def upload(access_key, secret_access_key, bucket, region)
      aws_secrets = {
        AccessKeyId: access_key,
        SecretAccessKey: secret_access_key,
        bucket: bucket,
        region: region
      }

      File.open(Rails.root.to_s + '/../aws-secrets.json', 'w') { |file| file.write(aws_secrets.to_json) }

      rake

      { status: 200, result: "Uploading postcodes from AWS bucket #{bucket}, region: #{region}" }
    rescue IOError => e
      #some error occur, dir not writable etc.
      { status: 404, error: e.to_s }
    rescue StandardError => e
      { status: 404, error: e.to_s }
    end

    def rake
      if File.split($PROGRAM_NAME).last == 'rake'
        Rails.logger.info('Guess what, I`m running this from Rake')
      else
        begin
          Rails.logger.info('No, this is not a Rake task')
          Rails.application.load_tasks
          Rake::Task['db:postcode'].execute
        rescue StandardError
          message = self.class.name + " data is missing! Please run 'rake db:postcode' to load postcode data."
          Rails.logger.info("\e[5;37;41m\n" + message + "\033[0m\n")
          raise error
        end
      end
    end
  end
end
