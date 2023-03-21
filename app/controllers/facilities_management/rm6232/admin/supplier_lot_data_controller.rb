module FacilitiesManagement
  module RM6232
    module Admin
      class SupplierLotDataController < FacilitiesManagement::Admin::FrameworkController
        before_action :set_supplier_data, only: :show
        before_action :set_lot_data, :set_lot_data_type_and_redirect_if_unrecognised, only: %i[edit update]
        before_action :set_data, only: :edit

        rescue_from ActiveRecord::RecordNotFound do
          redirect_to facilities_management_rm6232_admin_supplier_data_path
        end

        def show; end

        def edit; end

        def update
          @lot_data.assign_attributes(lot_data_params)

          if @lot_data.save(context: @lot_data_type.to_sym)
            FacilitiesManagement::RM6232::Admin::SupplierData::Edit.log_change(current_user, @lot_data)
            redirect_to facilities_management_rm6232_admin_supplier_lot_datum_path(id: @supplier.id)
          else
            set_data
            render :edit
          end
        end

        private

        def set_supplier_data
          @supplier = Supplier.find(params[:id])
          @lot_data = @supplier.lot_data.order('REVERSE(lot_code)').map do |lot_data|
            {
              id: lot_data.id,
              current_status: lot_data.current_status,
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
            set_work_packages
          when 'region_codes'
            set_regions
          end
        end

        def set_work_packages
          @work_packages = WorkPackage.selectable.index_with { |work_package| work_package.supplier_services.where(**LOT_NUMBER_TO_QUERY_PARAMS[@lot_code[0]]) }.reject { |_, service| service.empty? }
        end

        def set_regions
          @regions = Nuts1Region.all_with_overseas.to_h { |nuts_1_region| [nuts_1_region.name, Region.all.select { |region| region.code.starts_with? nuts_1_region.code }] }
        end

        def lot_data_params
          if params[:facilities_management_rm6232_supplier_lot_data]
            params.require(:facilities_management_rm6232_supplier_lot_data).permit(
              :active,
              service_codes: [],
              region_codes: [],
            )
          else
            { @lot_data_type => [] }
          end
        end

        RECOGNISED_LOT_DATA_TYPES = %w[lot_status service_codes region_codes].freeze
        LOT_NUMBER_TO_QUERY_PARAMS = {
          '1' => { total: true },
          '2' => { hard: true },
          '3' => { soft: true }
        }.freeze
      end
    end
  end
end
