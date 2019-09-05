module LegalServices
  class SuppliersController < FrameworkController
    before_action :fetch_suppliers, only: %i[index download]

    def index
      @back_path = :back
      @suppliers = Kaminari.paginate_array(@all_suppliers).page(params[:page])
      @lot = Lot.find_by(number: params[:lot])
    end

    def show
      @back_path = :back
      @supplier = Supplier.find(params[:id])
      @rate_card = @supplier.rate_cards.select { |rate_card| rate_card['lot'] == lot_rate_card_number }.first
      @lot = Lot.find_by(number: params[:lot])
    end

    def download
      @back_path = :back
    end

    private

    def lot_rate_card_number
      return params[:lot] unless params[:lot] == '2'

      params[:lot] + params[:jurisdiction]
    end

    def fetch_suppliers
      @all_suppliers = Supplier.offering_services_in_regions(
        params[:lot],
        params[:services],
        params[:jurisdiction],
        params[:region_codes]
      )
    end
  end
end
