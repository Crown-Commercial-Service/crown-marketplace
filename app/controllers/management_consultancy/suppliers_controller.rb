module ManagementConsultancy
  class SuppliersController < FrameworkController
    helper :telephone_number

    def index
      @journey = Journey.new(params[:slug], params)
      @back_path = @journey.previous_step_path

      @lot = Lot.find_by(number: params[:lot])
      @all_suppliers = Supplier.offering_services_in_regions(
        params[:lot],
        params[:services],
        params[:region_codes],
        params[:expenses] == 'paid'
      )

      @suppliers = Kaminari.paginate_array(@all_suppliers).page(params[:page])
    end

    def download; end
  end
end
