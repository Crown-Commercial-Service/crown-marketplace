const managementReportStateToProgress: StateToProgressWithoutProgressBar = {
  generating_csv: {
    wait: 15000,
    isFinished: false
  },
  completed: {
    wait: 0,
    isFinished: true
  }
}

$(() => {
  if ($('#management-report-status').length && $('.management-report-state-generating_csv').length) new FileUploadProgressWithoutBar(managementReportStateToProgress, 'generating_csv')
})
