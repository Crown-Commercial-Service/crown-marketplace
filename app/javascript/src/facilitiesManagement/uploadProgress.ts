type StateToProgressDefaultOptions = {
  wait: number
}

type StateToProgressWithProgressBarDefaultOptions = StateToProgressDefaultOptions & {
  progress: number
  state: string
}

type StateToProgressWithProgressBarNormalOptions = StateToProgressWithProgressBarDefaultOptions & {
  colourClass?: never
  isFinished?: never
}

type StateToProgressWithProgressBarFinishedOptions = StateToProgressWithProgressBarDefaultOptions & {
  colourClass: string
  isFinished: boolean
}

type StateToProgressWithoutProgressBarOptions = StateToProgressDefaultOptions & {
  isFinished: boolean
}

type StateToProgressWithProgressBar = {
  [key: string]: StateToProgressWithProgressBarNormalOptions | StateToProgressWithProgressBarFinishedOptions
}

type StateToProgressWithoutProgressBar = {
  [key: string]: StateToProgressWithoutProgressBarOptions
}

type FileUploadState = keyof StateToProgressWithProgressBar | keyof StateToProgressWithoutProgressBar

type FileUploadResponseJSON = {
  import_status: FileUploadState
}

interface FileUploadProgressInterface {
  url: string
  updateCurrentState: (newStatus: FileUploadState) => void
  stop: () => void
  processImportStatus: () => void
}

const checkImportProgress = (fileUploadProgress: FileUploadProgressInterface): void => {
  $.ajax({
    type: 'GET',
    url: fileUploadProgress.url,
    dataType: 'json',
    success(responseJSON: FileUploadResponseJSON) {
      fileUploadProgress.updateCurrentState(responseJSON.import_status)
    },
    error() {
      fileUploadProgress.stop()
    },
    complete() {
      fileUploadProgress.processImportStatus()
    },
  })
}

abstract class FileUploadProgress implements FileUploadProgressInterface {
  readonly url = `${window.location.pathname}/progress`
  protected continue = true
  protected stateToProgress: StateToProgressWithProgressBar | StateToProgressWithoutProgressBar
  protected currentState: StateToProgressWithProgressBarNormalOptions | StateToProgressWithProgressBarFinishedOptions | StateToProgressWithoutProgressBarOptions

  constructor(stateToProgress: StateToProgressWithProgressBar | StateToProgressWithoutProgressBar, initial_state: string) {
    this.stateToProgress = stateToProgress
    this.currentState = stateToProgress[initial_state]

    setTimeout(checkImportProgress.bind(null, this), 0)
  }

  protected processComplete = (): void => {
    window.location.reload()
  }

  updateCurrentState = (newStatus: FileUploadState): void => {
    this.currentState = this.stateToProgress[newStatus]
  }

  stop = (): void => {
    this.continue = false
  }

  abstract processImportStatus: () => void
}

class FileUploadProgressWithBar extends FileUploadProgress {
  private $progressBar: JQuery<HTMLElement> = $('#upload-import-progress')
  private $prgressStates: JQuery<HTMLElement> = $('.ccs-upload-progress-container > div')

  constructor(stateToProgress: StateToProgressWithProgressBar, initial_state: string) {
    super(stateToProgress, initial_state)
  }

  private updateProgressBar = (): void => {
    this.$prgressStates.each(this.updateShownStatus)
  }

  private updateShownStatus = (_index: number, element: HTMLElement): void => {
    if ($(element).attr('id') === (this.currentState as StateToProgressWithProgressBarNormalOptions | StateToProgressWithProgressBarFinishedOptions).state) {
      $(element).attr('aria-current', 'true')
      $(element).addClass('govuk-!-font-weight-bold')
    } else {
      $(element).removeAttr('aria-current')
      $(element).removeClass('govuk-!-font-weight-bold')
    }
  }

  processImportStatus = (): void => {
    if (this.continue) {
      this.$progressBar.attr('style', `width: ${(this.currentState as StateToProgressWithProgressBarNormalOptions | StateToProgressWithProgressBarFinishedOptions).progress}%`)
      this.updateProgressBar()
      let continueFunction = checkImportProgress.bind(null, this)

      if (this.currentState.isFinished) {
        this.$progressBar.addClass((this.currentState as StateToProgressWithProgressBarFinishedOptions).colourClass)
        continueFunction = this.processComplete
      }

      setTimeout(continueFunction, this.currentState.wait)
    } else {
      this.processComplete()
    }
  }
}

class FileUploadProgressWithoutBar extends FileUploadProgress {
  constructor(stateToProgress: StateToProgressWithoutProgressBar, initial_state: string) {
    super(stateToProgress, initial_state)
  }

  processImportStatus = (): void => {
    if (this.continue) {
      let continueFunction = checkImportProgress.bind(null, this)
  
      if (this.currentState.isFinished) {
        continueFunction = this.processComplete
      }
  
      setTimeout(continueFunction, this.currentState.wait)
    } else {
      this.processComplete()
    }
  }
}

export { StateToProgressWithProgressBar, StateToProgressWithoutProgressBar, FileUploadProgressWithBar, FileUploadProgressWithoutBar }
