module FacilitiesManagement
  module Admin
    class FrameworksController < FacilitiesManagement::Admin::FrameworkController
      before_action :raise_if_unrecognised_framework, except: %i[index edit update]
      before_action :set_framework, only: %i[edit update]

      def index
        @frameworks = Framework.all
      end

      def edit; end

      def update
        if @framework.update(framework_params)
          redirect_to facilities_management_admin_frameworks_path
        else
          render :edit
        end
      end

      private

      def set_framework
        @framework = Framework.find(params[:id])
      end

      def framework_params
        params.require(:facilities_management_framework)
              .permit(
                :live_at_dd,
                :live_at_mm,
                :live_at_yyyy,
              )
      end
    end
  end
end
