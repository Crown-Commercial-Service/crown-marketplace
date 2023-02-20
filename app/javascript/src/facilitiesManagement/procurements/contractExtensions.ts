interface NormalisationFactors {
  years: number
  months: number
  weeks: number
}

interface ButtonInterface {
  $button: JQuery<HTMLButtonElement>
  hideButton: () => void
  showButton: () => void
}

interface YearsAndMonthsInputInterface {
  $years: JQuery<HTMLInputElement>
  $months: JQuery<HTMLInputElement>
  yearsAndMonthsInomplete: () => boolean
  totalPeriod: () => number
}

interface ExtensionPeriodInterface {
  $years: JQuery<HTMLInputElement>
  $months: JQuery<HTMLInputElement>
  $removeButton: ContractPeriodButton
  showExtensionPeriod: () => void
  hideExtensionPeriod: () => void
  isNotVisible: () => boolean
  isRequired: () => boolean
}

interface ContractPeriodInterface {
  $mobilisationPeriodRequiredTrue: JQuery<HTMLInputElement>
  $mobilisationPeriodRequiredFalse: JQuery<HTMLInputElement>
  $periodInput: JQuery<HTMLInputElement>
  $extensionsRequiredTrue: JQuery<HTMLInputElement>
  $extensionsRequiredFalse: JQuery<HTMLInputElement>
  extensions: ExtensionPeriod[]
  extensionChecked: () => boolean
  allPeriodInputsComplete: () => boolean
  calculateTotalContractPeriod: () => void
  getTotalTimeRemaining: () => number
  timeRemaining: () => [number, number]
}

interface AddExtensionPeriodButtonInterface {
  ableToAddPeriod: () => boolean
  updateButtonVisibility: () => void
  updateButtonText: () => void
  updateButtonState: () => void
}

class ContractPeriodButton implements ButtonInterface {
  $button: JQuery<HTMLButtonElement>

  constructor ($button: JQuery<HTMLButtonElement>) {
    this.$button = $button
  }

  hideButton = (): void => {
    this.$button.addClass('govuk-visually-hidden')
    this.$button.attr('tabindex', -1)
  }

  showButton = (): void => {
    this.$button.removeClass('govuk-visually-hidden')
    this.$button.attr('tabindex', 0)
  }
}

const normalisationFactors: NormalisationFactors = {
  years: 156,
  months: 13,
  weeks: 3
}

const normaliseTimeLength = (inputElement: JQuery<HTMLInputElement>, factor: 'years' | 'months' | 'weeks'): number => parseInt(String(inputElement.val()), 10) * normalisationFactors[factor]

class YearsAndMonthsInput implements YearsAndMonthsInputInterface {
  $years: JQuery<HTMLInputElement>
  $months: JQuery<HTMLInputElement>

  constructor ($years: JQuery<HTMLInputElement>, $months: JQuery<HTMLInputElement>) {
    this.$years = $years
    this.$months = $months
  }

  private readonly normalisedYears = (): number => normaliseTimeLength(this.$years, 'years')

  private readonly normalisedMonths = (): number => normaliseTimeLength(this.$months, 'months')

  yearsAndMonthsInomplete = (): boolean => {
    const years: number = this.normalisedYears()
    const months: number = this.normalisedMonths()

    return Number.isNaN(years) || Number.isNaN(months) || (years + months) === 0
  }

  totalPeriod = (): number => {
    return this.normalisedYears() + this.normalisedMonths()
  }
}

class InitialCallOffPeriod extends YearsAndMonthsInput {
  constructor (framework: string) {
    super($(`#facilities_management_${framework}_procurement_initial_call_off_period_years`), $(`#facilities_management_${framework}_procurement_initial_call_off_period_months`))
  }
}

class ExtensionPeriod extends YearsAndMonthsInput implements ExtensionPeriodInterface {
  $removeButton: ContractPeriodButton

  private readonly $container: JQuery<HTMLInputElement>
  private readonly $required: JQuery<HTMLInputElement>

  constructor (framework: string, extension: number) {
    super($(`#facilities_management_${framework}_procurement_call_off_extensions_attributes_${extension}_years`), $(`#facilities_management_${framework}_procurement_call_off_extensions_attributes_${extension}_months`))
    this.$container = $(`#extension-${extension}-container`)
    this.$required = $(`#facilities_management_${framework}_procurement_call_off_extensions_attributes_${extension}_extension_required`)
    this.$removeButton = new ContractPeriodButton($(`#extension-${extension}-remove-button`))
  }

  showExtensionPeriod = (): void => {
    this.$container.removeClass('govuk-visually-hidden')
    this.$years.attr('tabindex', 0)
    this.$months.attr('tabindex', 0)
    this.$required.val('true')
    this.$removeButton.showButton()
  }

  hideExtensionPeriod = (): void => {
    this.$container.addClass('govuk-visually-hidden')
    this.resetInput(this.$years)
    this.resetInput(this.$months)
    this.$required.val('false')
    this.$container.find('.govuk-error-message').each((_, errorMessage: HTMLElement) => {
      $(errorMessage).remove()
    })
    this.$removeButton.hideButton()
  }

  private readonly resetInput = ($element: JQuery<HTMLInputElement>): void => {
    $element.attr('tabindex', -1)
    $element.val('')
    $element.removeClass('govuk-input--error')
  }

  isNotVisible = (): boolean => this.$container.hasClass('govuk-visually-hidden')

  isRequired = (): boolean => this.$required.val() === 'true'
}

class ContractPeriod implements ContractPeriodInterface {
  $mobilisationPeriodRequiredTrue: JQuery<HTMLInputElement>
  $mobilisationPeriodRequiredFalse: JQuery<HTMLInputElement>
  $periodInput: JQuery<HTMLInputElement> = $('.period-input')
  $extensionsRequiredTrue: JQuery<HTMLInputElement>
  $extensionsRequiredFalse: JQuery<HTMLInputElement>
  extensions: ExtensionPeriod[]

  private totalContractPeriod = 0
  private readonly initialCallOffPeriod: InitialCallOffPeriod
  private readonly $mobilisationPeriod: JQuery<HTMLInputElement>

  constructor (framework: string) {
    this.initialCallOffPeriod = new InitialCallOffPeriod(framework)
    this.$mobilisationPeriodRequiredTrue = $(`#facilities_management_${framework}_procurement_mobilisation_period_required_true`)
    this.$mobilisationPeriodRequiredFalse = $(`#facilities_management_${framework}_procurement_mobilisation_period_required_false`)
    this.$mobilisationPeriod = $(`#facilities_management_${framework}_procurement_mobilisation_period`)
    this.$extensionsRequiredTrue = $(`#facilities_management_${framework}_procurement_extensions_required_true`)
    this.$extensionsRequiredFalse = $(`#facilities_management_${framework}_procurement_extensions_required_false`)
    this.extensions = [...Array(4).keys()].map((extension: number) => new ExtensionPeriod(framework, extension))
  }

  private readonly mobilisationPeriodChecked = (): boolean => this.$mobilisationPeriodRequiredTrue.is(':checked')

  private readonly mobilisationPeriod = (): number => normaliseTimeLength(this.$mobilisationPeriod, 'weeks')

  extensionChecked = (): boolean => this.$extensionsRequiredTrue.is(':checked')

  fourthExtensionRequired = (): boolean => this.extensions[3].isRequired()

  allPeriodInputsComplete = (): boolean => {
    if (this.initialCallOffPeriod.yearsAndMonthsInomplete()) return false

    if (this.mobilisationPeriodChecked() && !(this.mobilisationPeriod() > 0)) return false

    let extensionsCompleted = true

    if (this.extensionChecked()) {
      extensionsCompleted = this.extensions.every((extension: ExtensionPeriod) => extension.isNotVisible() || !extension.yearsAndMonthsInomplete())
    }

    return extensionsCompleted
  }

  calculateTotalContractPeriod = (): void => {
    let totalPeriod = 0

    totalPeriod += this.initialCallOffPeriod.totalPeriod()

    totalPeriod += this.mobilisationPeriodChecked() ? this.mobilisationPeriod() : 0

    if (this.extensionChecked()) {
      this.extensions.forEach((extension: ExtensionPeriod) => {
        if (extension.isNotVisible()) return

        totalPeriod += extension.totalPeriod()
      })
    }

    this.totalContractPeriod = totalPeriod
  }

  getTotalTimeRemaining = (): number => 1560 - this.totalContractPeriod

  timeRemaining = (): [number, number] => {
    const totalTimeRemaining: number = this.getTotalTimeRemaining()

    const years: number = Math.floor(totalTimeRemaining / normalisationFactors.years)
    const months: number = Math.floor((totalTimeRemaining % normalisationFactors.years) / normalisationFactors.months)

    return [years, months]
  }
}

class $AddExtensionPeriodButton extends ContractPeriodButton implements AddExtensionPeriodButtonInterface {
  private readonly contractPeriod: ContractPeriod

  constructor (contractPeriod: ContractPeriod) {
    super($('#add-contract-extension-button'))
    this.contractPeriod = contractPeriod
  }

  ableToAddPeriod = (): boolean => {
    if (this.forthExtensionRequired()) return false
    if (!this.contractPeriod.allPeriodInputsComplete()) return false

    this.contractPeriod.calculateTotalContractPeriod()
    if (this.noTimePeriodLeftToAdd()) return false

    return true
  }

  updateButtonVisibility = (): void => {
    if (!this.contractPeriod.extensionChecked() || this.forthExtensionRequired() || this.noTimePeriodLeftToAdd()) {
      this.hideButton()
    } else {
      this.showButton()
    }
  }

  updateButtonText = (): void => {
    this.$button.text(this.getButtonText())
  }

  private readonly getButtonText = (): string => {
    const timeRemainingParts: number[] = this.contractPeriod.timeRemaining()
    const years: number = timeRemainingParts[0]
    const months: number = timeRemainingParts[1]

    let text = 'Add another extension period ('

    if (years > 0) text += `${years} year`
    if (years > 1) text += 's'
    if (years > 0 && months > 0) text += ' and '
    if (months > 0) text += `${months} month`
    if (months > 1) text += 's'

    return `${text} remaining)`
  }

  private readonly forthExtensionRequired = (): boolean => this.contractPeriod.fourthExtensionRequired()

  private readonly noTimePeriodLeftToAdd = (): boolean => this.contractPeriod.getTotalTimeRemaining() < 13

  updateButtonState = (): void => {
    if (this.contractPeriod.allPeriodInputsComplete()) {
      this.contractPeriod.calculateTotalContractPeriod()
      this.updateButtonVisibility()
      this.updateButtonText()
    }
  }
}

const initContractExtenesions = (): void => {
  const $callOffExtensionsContainer = $('#call-off-extensions')

  if ($callOffExtensionsContainer.length > 0) {
    const framework: string = $callOffExtensionsContainer.data().framework
    const contractPeriod: ContractPeriod = new ContractPeriod(framework)
    const addExtensionPeriodButton: $AddExtensionPeriodButton = new $AddExtensionPeriodButton(contractPeriod)

    contractPeriod.$extensionsRequiredTrue.on('click', () => {
      contractPeriod.extensions[0].showExtensionPeriod()
      addExtensionPeriodButton.hideButton()
      if (addExtensionPeriodButton.ableToAddPeriod()) addExtensionPeriodButton.showButton()
    })

    contractPeriod.$extensionsRequiredFalse.on('click', () => {
      contractPeriod.extensions.forEach((extension: ExtensionPeriod) => { extension.hideExtensionPeriod() })
      addExtensionPeriodButton.hideButton()
    })

    contractPeriod.extensions.forEach((extension: ExtensionPeriod, index: number) => {
      extension.$removeButton.$button.on('click', (event: JQuery.ClickEvent) => {
        event.preventDefault()

        extension.hideExtensionPeriod()
        contractPeriod.extensions[index - 1].$removeButton.showButton()

        if (addExtensionPeriodButton.ableToAddPeriod()) {
          addExtensionPeriodButton.updateButtonVisibility()
          addExtensionPeriodButton.updateButtonText()
        }
      })
    })

    addExtensionPeriodButton.$button.on('click', (event: JQuery.ClickEvent) => {
      event.preventDefault()

      if (addExtensionPeriodButton.ableToAddPeriod()) {
        const nextExtensionIndex = 4 - $('.extension-container.govuk-visually-hidden').length

        contractPeriod.extensions[nextExtensionIndex].showExtensionPeriod()
        contractPeriod.extensions[nextExtensionIndex - 1].$removeButton.hideButton()

        addExtensionPeriodButton.updateButtonVisibility()
        addExtensionPeriodButton.updateButtonText()
      }
    })

    contractPeriod.$periodInput.on('keyup', () => {
      addExtensionPeriodButton.updateButtonState()
    })

    contractPeriod.$mobilisationPeriodRequiredTrue.on('click', () => {
      addExtensionPeriodButton.updateButtonState()
    })

    contractPeriod.$mobilisationPeriodRequiredFalse.on('click', () => {
      addExtensionPeriodButton.updateButtonState()
    })

    if (addExtensionPeriodButton.ableToAddPeriod()) {
      addExtensionPeriodButton.updateButtonText()
      addExtensionPeriodButton.updateButtonVisibility()
    } else {
      addExtensionPeriodButton.hideButton()
    }
  }
}

export default initContractExtenesions
