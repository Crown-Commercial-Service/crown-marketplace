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
               else
                 PostcodeChecker.location_info(params[:id])
               end
      render json: result
    end
  end
end
