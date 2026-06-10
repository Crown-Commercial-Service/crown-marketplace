import { FileUploadProgressWithBar, type StateToProgressWithProgressBar } from './uploadProgress'

const reportStateToProgress: StateToProgressWithProgressBar = {
  generating_csv: {
    progress: 50,
    wait: 5000,
    state: 'progress-1'
  },
  completed: {
    progress: 100,
    wait: 1000,
    state: 'progress-2',
    colourClass: 'ccs-progress-bar--succeed',
    isFinished: true
  },
  failed: {
    progress: 100,
    wait: 1000,
    state: 'progress-2',
    colourClass: 'ccs-progress-bar--fail',
    isFinished: true
  },
}

const initReportProgress = (): void => {
  if ($('#report-generation-progress').length) new FileUploadProgressWithBar(reportStateToProgress, 'generating_csv')
}

export default initReportProgress
