require 'management_consultancy/journey'

module ManagementConsultancy
  class SuppliersController < ApplicationController
    helper :telephone_number

    def index
      @journey = Journey.new(params[:slug], params)
      @back_path = @journey.previous_step_path

      @lot = Lot.find_by(number: params[:lot])
      @suppliers = Supplier.offering_services_in_regions(
        params[:lot],
        params[:services],
        params[:region_codes]
      )
    end
  end
end
