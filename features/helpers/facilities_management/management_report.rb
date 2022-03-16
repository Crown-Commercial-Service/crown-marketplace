def stub_management_report
  allow(FacilitiesManagement::RM3830::Admin::ManagementReportWorker).to receive(:perform_async).and_return(nil)
end
