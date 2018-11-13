require 'management_consultancy/journey'

module ManagementConsultancy
  class SuppliersController < ApplicationController
    def index
      @journey = Journey.new(params[:slug], params)
      @back_path = @journey.previous_step_path
    end
  end
end
