module FacilitiesManagement
  module Beta
    class ProcurementsController < FacilitiesManagement::FrameworkController
      before_action :set_procurement, only: %i[show edit update destroy]
      before_action :set_edit_state, only: %i[show edit]

      def index
        @procurements = current_user.procurements.sort_by do |proc|
          proc[:name]
        end
      end

      def show; end

      def new
        @procurement = current_user.procurements.build
      end

      def create
        @procurement = current_user.procurements.create(procurement_params)

        if @procurement.save
          redirect_to facilities_management_beta_procurement_url(id: @procurement.id)
        else
          render :new
        end
      end

      def edit; end

      def update
        if @procurement.update(procurement_params)
          redirect_to FacilitiesManagement::ProcurementRouter.new(id: @procurement.id, step: params[:step]).route
        else
          render :edit
        end
      end

      def destroy; end

      private

      def procurement_params
        params.require(:facilities_management_procurement)
              .permit(
                :name,
                :procurement_data
              )
      end

      def set_procurement
        @procurement = Procurement.find(params[:id])
      end

      def set_edit_state
        @delete = params.include? 'delete'
        @change = !@delete && action_name == 'edit'
      end
    end
  end
end
