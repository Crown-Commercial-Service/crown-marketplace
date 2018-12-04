module ManagementConsultancy
  class SuppliersController < FrameworkController
    require_permission :management_consultancy

    helper :telephone_number

    def index
      @journey = Journey.new(params[:slug], params)
      @back_path = @journey.previous_step_path

      @lot = Lot.find_by(number: params[:lot])
      @suppliers = Supplier.offering_services_in_regions(
        params[:lot],
        params[:services],
        params[:region_codes],
        params[:expenses] == 'paid'
      )
    end
  end
end
