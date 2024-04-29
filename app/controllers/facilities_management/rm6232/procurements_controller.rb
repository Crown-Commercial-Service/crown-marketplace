module FacilitiesManagement
  module RM6232
    class ProcurementsController < FacilitiesManagement::FrameworkController
      before_action :set_procurement, only: %i[show update_show supplier_shortlist_spreadsheet]
      before_action :authorize_user
      before_action :redirect_if_missing_regions, only: :show

      def index
        @searches = current_user.rm6232_procurements.order(updated_at: :asc)
        set_back_path(:index)
      end

      def show
        set_back_path(:show)
      end

      def new
        @procurement = current_user.rm6232_procurements.build(
          service_codes: params[:service_codes],
          region_codes: params[:region_codes],
          annual_contract_value: params[:annual_contract_value]
        )

        @procurement.lot_number = @procurement.quick_view_suppliers.lot_number
        @suppliers = @procurement.quick_view_suppliers.selected_suppliers
        set_back_path(:new)
      end

      def create
        @procurement = current_user.rm6232_procurements.build(procurement_params(:new))

        if @procurement.save(context: :contract_name)
          if params[:save_and_return].present?
            redirect_to facilities_management_rm6232_procurements_path
          else
            redirect_to facilities_management_rm6232_procurement_path(@procurement)
          end
        else
          build_new_procurement
          set_back_path(:new)
          render :new
        end
      end

      def update_show
        if (params[:change_requirements] && @procurement.go_back_to_entering_requirements!) || (@procurement.valid?(@procurement.aasm_state.to_sym) && @procurement.set_to_next_state!)
          redirect_to facilities_management_rm6232_procurement_path(id: @procurement.id)
        else
          set_back_path(:show)
          render :show
        end
      end

      def supplier_shortlist_spreadsheet
        spreadsheet_builder = SupplierShortlistSpreadsheetCreator.new(@procurement.id)
        spreadsheet_builder.build
        send_data spreadsheet_builder.to_xlsx, filename: "Supplier shortlist (#{@procurement.contract_name}).xlsx", type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
      end

      private

      def redirect_if_missing_regions
        redirect_to facilities_management_rm6232_missing_regions_path(procurement_id: @procurement.id) if @procurement.procurement_buildings_missing_regions?
      end

      # rubocop:disable Naming/AccessorMethodName
      def set_back_path(action)
        @back_path, @back_text = case action
                                 when :index
                                   [facilities_management_rm6232_path, t('facilities_management.rm6232.procurements.index.return_to_your_account')]
                                 when :show
                                   [facilities_management_rm6232_procurements_path, t('facilities_management.rm6232.procurements.show.return_to_saved_searches')]
                                 when :new
                                   [helpers.journey_step_url_former(journey_slug: 'annual-contract-value', annual_contract_value: @procurement.annual_contract_value, region_codes: @procurement.region_codes, service_codes: @procurement.service_codes), t('facilities_management.rm6232.procurements.new.return_to_contract_cost')]
                                 end
      end
      # rubocop:enable Naming/AccessorMethodName

      def build_new_procurement
        @procurement ||= current_user.rm6232_procurements.build(
          service_codes: params[:service_codes],
          region_codes: params[:region_codes],
          annual_contract_value: params[:annual_contract_value]
        )

        @procurement.lot_number = @procurement.quick_view_suppliers.lot_number
        @suppliers = @procurement.quick_view_suppliers.selected_suppliers
      end

      def set_procurement
        @procurement = Procurement.find(params[:id] || params[:procurement_id])
      end

      def procurement_params(page = @page)
        @procurement_params ||= params.require(:facilities_management_rm6232_procurement).permit(PERMITED_PARAMS[page])
      end

      PERMITED_PARAMS = {
        new: [:contract_name, :annual_contract_value, { service_codes: [], region_codes: [] }]
      }.freeze

      protected

      def authorize_user
        @procurement ? (authorize! :manage, @procurement) : (authorize! :read, FacilitiesManagement)
      end
    end
  end
end
