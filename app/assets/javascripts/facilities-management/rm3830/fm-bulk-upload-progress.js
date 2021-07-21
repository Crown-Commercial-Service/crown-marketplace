const bulkUploadStateToProgress = {
  not_started: {
    progress: 10,
    wait: 1000,
    state: 'progress-0',
  },
  in_progress: {
    progress: 10,
    wait: 1000,
    state: 'progress-0',
  },
  checking_file: {
    progress: 30,
    wait: 1000,
    state: 'progress-1',
  },
  processing_file: {
    progress: 50,
    wait: 2000,
    state: 'progress-2',
  },
  checking_processed_data: {
    progress: 50,
    wait: 2000,
    state: 'progress-2',
  },
  saving_data: {
    progress: 70,
    wait: 15000,
    state: 'progress-3',
  },
  data_import_succeed: {
    progress: 100,
    wait: 1000,
    state: 'progress-4',
    colourClass: 'ccs-progress-bar--succeed',
  },
  data_import_failed: {
    progress: 100,
    wait: 1000,
    state: 'progress-4',
    colourClass: 'ccs-progress-bar--fail',
  },
};

$(() => {
  if ($('#bulk-upload-import').length) {
    uploadFileImport.init(bulkUploadStateToProgress, 'data_import_succeed', 'data_import_failed');
  }
});
