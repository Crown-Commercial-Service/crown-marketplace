require 'management_consultancy/journey'

module ManagementConsultancy
  class SuppliersController < ApplicationController
    def index
      @journey = Journey.new(params[:slug], params)
      @back_path = @journey.previous_step_path

      lot_number = /lot(\d)/.match(params[:lot])[1]
      @lot = Lot.find_by(number: lot_number)
      @suppliers = Supplier.available_in_lot(@lot.number)
    end
  end
end
