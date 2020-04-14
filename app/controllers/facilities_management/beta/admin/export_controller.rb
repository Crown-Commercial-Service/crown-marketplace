module FacilitiesManagement
  module Beta
    module Admin
      class ExportController < ::ApplicationController
        before_action :authenticate_user!
        before_action :authorize_user

        def start; end

        def export
          current_user.csv_export.purge
          csv_string = ProcurementCsvExport.call
          current_user.csv_export.attach(io: StringIO.new(csv_string), filename: 'procurements_data.csv', content_type: 'text/csv')
          render :download
        end

        protected

        def authorize_user
          authorize! :manage, FacilitiesManagement::Beta::Admin
        end
      end
    end
  end
end
