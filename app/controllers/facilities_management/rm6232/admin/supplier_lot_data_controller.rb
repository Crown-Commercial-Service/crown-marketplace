module FacilitiesManagement
  module RM6232
    module Admin
      class SupplierLotDataController < FacilitiesManagement::Admin::FrameworkController
        before_action :set_supplier_data, only: :show
        before_action :set_lot_data, :set_lot_data_type_and_redirect_if_unrecognised, only: %i[edit update]
        before_action :set_data, only: :edit

        def show; end

        def edit; end

        def update
          @lot_data.assign_attributes(lot_data_params)

          if @lot_data.save(context: @lot_data_type.to_sym)
            redirect_to facilities_management_rm6232_admin_supplier_lot_datum_path(id: @supplier.id)
          else
            set_data
            render :edit
          end
        end

        private

        def set_supplier_data
          @supplier = Supplier.find(params[:id])
          @lot_data = @supplier.lot_data.order(:lot_code).map do |lot_data|
            {
              id: lot_data.id,
              lot_code: lot_data.lot_code,
              service_names: lot_data.services.map(&:name),
              region_names: lot_data.regions.map(&:name)
            }
          end
        end

        def set_lot_data
          @lot_data = Supplier::LotData.find(params[:supplier_lot_datum_id])
          @lot_code = @lot_data.lot_code
          @supplier = @lot_data.supplier
        end

        def set_lot_data_type_and_redirect_if_unrecognised
          @lot_data_type = params[:lot_data_type]

          redirect_to facilities_management_rm6232_admin_path unless RECOGNISED_LOT_DATA_TYPES.include? @lot_data_type
        end

        def set_data
          case @lot_data_type
          when 'service_codes'
            # TODO: Add method for services
          when 'region_codes'
            set_regions
          end
        end

        def set_regions
          @regions = Nuts1Region.all.map { |nuts_1_region| [nuts_1_region.name, Region.all.select { |region| region.code.starts_with? nuts_1_region.code }] }.to_h
        end

        def lot_data_params
          if params[:facilities_management_rm6232_supplier_lot_data]
            params.require(:facilities_management_rm6232_supplier_lot_data).permit(
              region_codes: [],
            )
          else
            { @lot_data_type => [] }
          end
        end

        RECOGNISED_LOT_DATA_TYPES = %w[region_codes].freeze
      end
    end
  end
end
