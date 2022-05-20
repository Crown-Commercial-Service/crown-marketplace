module FacilitiesManagement
  module RM6232
    class ProcurementsController < FacilitiesManagement::FrameworkController
      before_action :set_procurement, only: %i[show]
      before_action :authorize_user
      before_action :build_new_procurement, :set_back_path, only: :new

      def new
        @procurement = current_user.rm6232_procurements.build(service_codes: params[:service_codes],
                                                              region_codes: params[:region_codes],
                                                              annual_contract_value: params[:annual_contract_value])

        @procurement.lot_number = @procurement.quick_view_suppliers.lot_number
        @suppliers = @procurement.quick_view_suppliers.selected_suppliers
      end

      def create
        @procurement = current_user.rm6232_procurements.build(procurement_params(:new))

        if @procurement.save(context: :contract_name)
          if params[:save_and_return].present?
            # TODO: Change to dashboard facilities_management_rm6232_procurements_path
            redirect_to facilities_management_rm6232_path
          else
            redirect_to facilities_management_rm6232_procurement_path(@procurement)
          end
        else
          build_new_procurement
          set_back_path
          render :new
        end
      end

      def show
        # TODO: Change to dashboard path facilities_management_rm6232_procurements_path
        @back_path = '#'
        @back_text = t('facilities_management.rm6232.procurements.show.return_to_procurement_dashboard')
      end

      private

      def set_back_path
        @back_path = helpers.journey_step_url_former(journey_slug: 'annual-contract-value', annual_contract_value: @procurement.annual_contract_value, region_codes: @procurement.region_codes, service_codes: @procurement.service_codes)
        @back_text = t('facilities_management.rm6232.procurements.new.return_to_contract_cost')
      end

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
