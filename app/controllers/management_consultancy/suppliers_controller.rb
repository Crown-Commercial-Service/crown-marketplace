require 'management_consultancy/journey'

module ManagementConsultancy
  class SuppliersController < ApplicationController
    helper :telephone_number

    def index
      @journey = Journey.new(params[:slug], params)
      @back_path = @journey.previous_step_path

      @lot = Lot.find_by(number: params[:lot])
      @suppliers = Supplier.offering_services(params[:lot], params[:services])
    end
  end
end
