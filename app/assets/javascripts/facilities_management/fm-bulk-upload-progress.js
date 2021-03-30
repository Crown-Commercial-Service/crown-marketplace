$(() => {
  const bulkUploadStatus = {
    procurementID: $('#procurement_id').val(),
    spreadsheetImportID: $('#spreadsheet_import_id').val(),
    url: '',
    interval: 1000,
    checks: 0,

    init() {
      this.url = `/facilities-management/procurements/${this.procurementID}/spreadsheet_imports/${this.spreadsheetImportID}/progress`;

      setTimeout(this.checkUploadProgress, this.interval);
    },

    processImportStatus(status) {
      if (status) {
        window.location.reload();
      }
    },

    checkIfContinue(data) {
      if (data.status === 200) {
        if (data.responseJSON.continue) {
          if (this.checks < 30) this.checks++;
          if (this.checks === 30) this.interval = 1500;

          setTimeout(this.checkUploadProgress, this.interval);
        }
      }
    },

    checkUploadProgress() {
      $.ajax({
        type: 'GET',
        url: bulkUploadStatus.url,
        data: $(this).serialize(),
        dataType: 'json',
        success(data) {
          bulkUploadStatus.processImportStatus(data.refresh);
        },
        complete(data) {
          bulkUploadStatus.checkIfContinue(data);
        },
      });
    },
  };

  if ($('#bulk-upload-in-progress').length) {
    bulkUploadStatus.init();
  }
});