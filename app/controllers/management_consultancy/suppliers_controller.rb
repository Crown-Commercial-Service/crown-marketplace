module ManagementConsultancy
  class SuppliersController < FrameworkController
    helper :telephone_number
    before_action :fetch_suppliers, only: [:index]

    def index
      @journey = Journey.new(params[:slug], params)
      @back_path = @journey.previous_step_path
      @lot = Lot.find_by(number: params[:lot])
      @suppliers = Kaminari.paginate_array(@all_suppliers).page(params[:page])
    end

    def show
      @supplier = Supplier.find(params[:id])
    end

    def download; end

    private

    def fetch_suppliers
      @all_suppliers = Supplier.offering_services_in_regions(
        params[:lot],
        params[:services],
        params[:region_codes],
        params[:expenses] == 'paid'
      ).joins(:rate_cards)
                               .where(management_consultancy_rate_cards: { lot: params[:lot] })
                               .sort_by { |supplier| supplier.rate_cards.first.average_daily_rate }
    end
  end
end
