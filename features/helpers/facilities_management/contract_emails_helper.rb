def stub_contract_emails
  allow(FacilitiesManagement::GovNotifyNotification).to receive(:perform_async).and_return(nil)
  allow(FacilitiesManagement::RM3830::GenerateContractZip).to receive(:perform_in).and_return(nil)
  allow(FacilitiesManagement::RM3830::ChangeStateWorker).to receive(:perform_at).and_return(nil)
  allow(FacilitiesManagement::RM3830::ContractSentReminder).to receive(:perform_at).and_return(nil)
  allow(FacilitiesManagement::RM3830::AwaitingSignatureReminder).to receive(:perform_at).and_return(nil)
end
