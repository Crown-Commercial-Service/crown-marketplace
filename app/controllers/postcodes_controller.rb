# frozen_string_literal: true

module Postcodes
  # return json
  class PostcodesController < ApplicationController
    protect_from_forgery with: :exception

    # GET /postcodes/SW1A 2AA
    # GET /postcodes/SW1A 2AA.json
    def show
      postcode_string = PostcodeChecker.location_info(params[:id])
      render json: postcode_string
    end
  end
end
