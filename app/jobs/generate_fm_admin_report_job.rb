class GenerateFMAdminReportJob < ApplicationJob
  queue_as :fm

  def perform(id)
    FacilitiesManagement::Admin::ManagementReportCsvGenerator.new(id).generate
  end
end
