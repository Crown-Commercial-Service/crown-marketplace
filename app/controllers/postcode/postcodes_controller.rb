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
      result = query(params[:id])

      render json: { status: 200, result: result }
    rescue StandardError => e
      render json: { status: 404, error: e.to_s }
    end

    private

    def query(param)
      case param
      when 'in_london'
        PostcodeChecker.in_london? params[:postcode]
      when 'clear'
        PostcodeChecker.clear(params[:access_key], params[:secret_access_key])
      when 'count'
        PostcodeChecker.count(params[:access_key], params[:secret_access_key])
      when 'upload'
        upload(params[:access_key], params[:secret_access_key], params[:bucket], params[:region])
      else
        PostcodeChecker.location_info(param)
      end
    end

    def upload(access_key, secret_access_key, bucket, region)
      flag = PostcodeChecker.table_exists
      if flag
        rows = PostcodeChecker.count(access_key, secret_access_key)
        return "There are already #{rows} rows of postcodes data! Please clear that data first.\n" unless rows.zero?
      end
      PostcodeChecker.upload(access_key, secret_access_key, bucket, region)
    end
  end
end
