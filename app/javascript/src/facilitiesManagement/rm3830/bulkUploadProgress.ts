import { FileUploadProgressWithBar, type StateToProgressWithProgressBar } from '../uploadProgress'

const bulkUploadStateToProgress: StateToProgressWithProgressBar = {
  not_started: {
    progress: 10,
    wait: 1000,
    state: 'progress-0'
  },
  in_progress: {
    progress: 10,
    wait: 1000,
    state: 'progress-0'
  },
  checking_file: {
    progress: 30,
    wait: 1000,
    state: 'progress-1'
  },
  processing_file: {
    progress: 50,
    wait: 2000,
    state: 'progress-2'
  },
  checking_processed_data: {
    progress: 50,
    wait: 2000,
    state: 'progress-2'
  },
  saving_data: {
    progress: 70,
    wait: 15000,
    state: 'progress-3'
  },
  data_import_succeed: {
    progress: 100,
    wait: 1000,
    state: 'progress-4',
    colourClass: 'ccs-progress-bar--succeed',
    isFinished: true
  },
  data_import_failed: {
    progress: 100,
    wait: 1000,
    state: 'progress-4',
    colourClass: 'ccs-progress-bar--fail',
    isFinished: true
  }
}

const initBulkUpload = (): void => {
  if ($('#bulk-upload-import').length) new FileUploadProgressWithBar(bulkUploadStateToProgress, 'in_progress')
}

export default initBulkUpload
