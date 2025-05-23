import { get } from '@rails/request.js'

interface StateToProgressDefaultOptions {
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

type StateToProgressWithProgressBar = Record<string, StateToProgressWithProgressBarNormalOptions | StateToProgressWithProgressBarFinishedOptions>

type StateToProgressWithoutProgressBar = Record<string, StateToProgressWithoutProgressBarOptions>

type FileUploadState = keyof StateToProgressWithProgressBar | keyof StateToProgressWithoutProgressBar

interface FileUploadResponseJSON {
  import_status: FileUploadState
}

interface FileUploadProgressInterface {
  url: string
  updateCurrentState: (newStatus: FileUploadState) => void
  stop: () => void
  processImportStatus: () => Promise<void>
}

const checkImportProgress = async (fileUploadProgress: FileUploadProgressInterface): Promise<void> => {
  try {
    const response = await get(
      fileUploadProgress.url,
      {
        responseKind: 'json',
      }
    )

    if (response.ok) {
      const responseJSON: FileUploadResponseJSON = await response.json

      fileUploadProgress.updateCurrentState(responseJSON.import_status)
    } else {
      fileUploadProgress.stop()
    }
  } catch {
    fileUploadProgress.stop()
  } finally {
    await fileUploadProgress.processImportStatus()
  }
}

abstract class FileUploadProgress implements FileUploadProgressInterface {
  readonly url = `${window.location.pathname}/progress`
  protected continue = true
  protected stateToProgress: StateToProgressWithProgressBar | StateToProgressWithoutProgressBar
  protected currentState: StateToProgressWithProgressBarNormalOptions | StateToProgressWithProgressBarFinishedOptions | StateToProgressWithoutProgressBarOptions

  constructor (stateToProgress: StateToProgressWithProgressBar | StateToProgressWithoutProgressBar, initialState: string) {
    this.stateToProgress = stateToProgress
    this.currentState = stateToProgress[initialState]

    setTimeout(checkImportProgress.bind(null, this), 0)
  }

  protected processComplete = async (): Promise<void> => {
    window.location.reload()
  }

  updateCurrentState = (newStatus: FileUploadState): void => {
    this.currentState = this.stateToProgress[newStatus]
  }

  stop = (): void => {
    this.continue = false
  }

  abstract processImportStatus: () => Promise<void>
}

class FileUploadProgressWithBar extends FileUploadProgress {
  private readonly $progressBar: JQuery<HTMLElement> = $('#upload-import-progress')
  private readonly $prgressStates: JQuery<HTMLElement> = $('.ccs-upload-progress-container > div')

  constructor (stateToProgress: StateToProgressWithProgressBar, initialState: string) {
    super(stateToProgress, initialState)
  }

  private readonly updateProgressBar = (): void => {
    this.$prgressStates.each(this.updateShownStatus)
  }

  private readonly updateShownStatus = (_index: number, element: HTMLElement): void => {
    if ($(element).attr('id') === (this.currentState as StateToProgressWithProgressBarNormalOptions | StateToProgressWithProgressBarFinishedOptions).state) {
      $(element).attr('aria-current', 'true')
      $(element).addClass('govuk-!-font-weight-bold')
    } else {
      $(element).removeAttr('aria-current')
      $(element).removeClass('govuk-!-font-weight-bold')
    }
  }

  processImportStatus = async (): Promise<void> => {
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
      await this.processComplete()
    }
  }
}

class FileUploadProgressWithoutBar extends FileUploadProgress {
  constructor (stateToProgress: StateToProgressWithoutProgressBar, initialState: string) {
    super(stateToProgress, initialState)
  }

  processImportStatus = async (): Promise<void> => {
    if (this.continue) {
      let continueFunction = checkImportProgress.bind(null, this)

      if (this.currentState.isFinished) {
        continueFunction = this.processComplete
      }

      setTimeout(continueFunction, this.currentState.wait)
    } else {
      await this.processComplete()
    }
  }
}

export { type StateToProgressWithProgressBar, type StateToProgressWithoutProgressBar, FileUploadProgressWithBar, FileUploadProgressWithoutBar }
