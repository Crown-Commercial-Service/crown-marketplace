module ManagementConsultancy
  class SuppliersController < FrameworkController
    helper :telephone_number
    before_action :fetch_suppliers, only: %i[index download]
    before_action :set_back_path

    def index
      @journey = Journey.new(params[:slug], params)
      @lot = Lot.find_by(number: params[:lot])
      @suppliers = Kaminari.paginate_array(@all_suppliers).page(params[:page])
    end

    def show
      @supplier = Supplier.find(params[:id])
      @lot = Lot.find_by(number: params[:lot])
      @rate_card = @supplier.rate_cards.where(lot: params[:lot]).first
    end

    def download
      respond_to do |format|
        format.html
        format.xlsx do
          spreadsheet_builder = ManagementConsultancy::SupplierSpreadsheetCreator.new(@all_suppliers, params)
          spreadsheet = spreadsheet_builder.build
          render xlsx: spreadsheet.to_stream.read, filename: 'shortlist.xlsx', format: 'application/vnd.openxmlformates-officedocument.spreadsheetml.sheet'
        end
      end
    end

    private

    def fetch_suppliers
      @all_suppliers = Supplier.offering_services_in_regions(
        params[:lot],
        params[:services],
        params[:region_codes]
      ).joins(:rate_cards)
                               .where(management_consultancy_rate_cards: { lot: params[:lot] })
                               .sort_by { |supplier| supplier.rate_cards.first.average_daily_rate }
    end

    def set_back_path
      @back_path = :back
    end
  end
end
