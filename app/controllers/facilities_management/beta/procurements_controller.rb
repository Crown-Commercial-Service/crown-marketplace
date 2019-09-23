module FacilitiesManagement
  module Beta
    class ProcurementsController < FacilitiesManagement::FrameworkController
      before_action :set_procurement, only: %i[show edit update destroy]

      def index
        @procurements = current_user.procurements
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
          redirect_to facilities_management_beta_procurement_url(id: @procurement.id)
        else
          render :edit
        end
      end

      # DELETE /procurements/1
      # DELETE /procurements/1.json
      def destroy
        @procurement.destroy

        respond_to do |format|
          format.html { redirect_to facilities_management_beta_procurements_url }
          format.json { head :no_content }
        end
      end

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
    end
  end
end
