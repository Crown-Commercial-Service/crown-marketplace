const managementReportProgress = {
  continue: true,
  currentState: 'generating_csv',
  interval: 15000,

  init() {
    this.statusURL = `${window.location.pathname}/progress`;

    setTimeout(this.checkImportProgress, this.interval);
  },

  checkImportProgress() {
    $.ajax({
      type: 'GET',
      url: managementReportProgress.statusURL,
      data: $(this).serialize(),
      dataType: 'json',
      success(data) {
        managementReportProgress.currentState = data.status;
      },
      error() {
        managementReportProgress.continue = false;
      },
      complete() {
        managementReportProgress.processImportStatus();
      },
    });
  },

  processImportStatus() {
    if (this.continue) {
      if (this.currentState === 'completed') {
        this.processComplete();
      } else {
        setTimeout(this.checkImportProgress, this.interval);
      }
    }
  },

  processComplete() {
    window.location.reload();
  },
};

$(() => {
  if ($('#management-report-status').length && $('.management-report-state-generating_csv').length) {
    managementReportProgress.init();
  }
});
