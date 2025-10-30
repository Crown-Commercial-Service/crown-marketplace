import { get } from '@rails/request.js'

enum StateToView {
  postcodeSearch = 1,
  selectAddress = 2,
  enterAddress = 3,
}

type PostcodeResult = {
  valid: false
  input: string
  fullPostcode?: never
} | {
  valid: true
  input: string
  fullPostcode: string
}

interface AddressResult {
  summary_line: string
  address_line_1: string
  address_line_2: string
  address_town: string
  address_postcode: string
}


interface Section {
  toggleVisability: (state: StateToView) => void
  focus: () => void
}

class ErrorSummarySection {
  $errorSummary: JQuery<HTMLElement>
  errorSummaryElements: {[key: string]: JQuery<HTMLElement>} = {}

  constructor () {
    this.$errorSummary = $('.govuk-error-summary')
    this.$errorSummary.find('.govuk-error-summary__list > li').each((_index, element) => {
      const $element = $(element)

      this.errorSummaryElements[$element.find('a').attr('href') as string] = $element
    })
  }

  removeError = (errorId: string) => {
    const errorKey = `#${errorId}`

    if (errorKey in this.errorSummaryElements) {
      this.errorSummaryElements[errorKey].remove()
      delete this.errorSummaryElements[errorKey]

      if (Object.keys(this.errorSummaryElements).length === 0) {
        this.$errorSummary.remove()
      }
    }
  }
}

class AddressField {
  errorSummarySection: ErrorSummarySection
  $formGroup: JQuery<HTMLInputElement>
  $field: JQuery<HTMLInputElement>
  errorMessageId: string
  errorMessageText: string
  $errorMessage?: JQuery<HTMLElement>

  constructor(fieldClass: string, errorSummarySection: ErrorSummarySection) {
    this.$field = $(`.${fieldClass}`)
    this.errorSummarySection = errorSummarySection

    const fieldId = ((this.$field.attr('name') as string).match(/(?<=\[)(.*?)(?=\])/) as string[])[0]

    this.$formGroup = $(`#${fieldId}-form-group`)
    this.errorMessageId = `${fieldId}-error`
    this.errorMessageText = this.$field.data('errorMessage')
    this.$errorMessage = $(`#${this.errorMessageId}`)
  }

  showError = (): void => {
    const errorMessageHTML = `<span id="${this.errorMessageId}" class="govuk-error-message">${this.errorMessageText}</span>`

    this.$field.before(errorMessageHTML)
    this.$errorMessage = $(`#${this.errorMessageId}`)

    this.$formGroup.addClass('govuk-form-group--error')
    this.$field.addClass('govuk-input--error')
  }

  clearError = (): void => {
    if (this.$errorMessage !== undefined) {
      this.$errorMessage.remove()
      delete this.$errorMessage
      this.errorSummarySection.removeError(this.errorMessageId)
    }

    this.$formGroup.removeClass('govuk-form-group--error')
    this.$field.removeClass('govuk-input--error')
  }

  toggleVisability = (isShown: boolean) => {
    if (isShown) {
      this.$field.removeAttr('tabindex')
    } else {
      this.$field.attr('tabindex', '-1')
      this.clearError()
    }
  }

  val = (value?: string) => {
    if (value === undefined) {
      return this.$field.val()
    } else {
      return this.$field.val(value)
    }
  }

  focus = () => {
    this.$field.trigger('focus')
  }
}

class EnterAddressSection implements Section {
  findAddress: FindAddress
  $enterAddressSection: JQuery<HTMLElement>
  addressLine1Field: AddressField
  addressLine2Field: AddressField
  townOrCityField: AddressField
  countyField: AddressField

  constructor (findAddress: FindAddress, $enterAddressSection: JQuery<HTMLElement>, errorSummarySection: ErrorSummarySection) {
    this.findAddress = findAddress
    this.$enterAddressSection = $enterAddressSection
    this.addressLine1Field = new AddressField('organisation-address--address-line-1', errorSummarySection)
    this.addressLine2Field = new AddressField('organisation-address--address-line-2', errorSummarySection)
    this.townOrCityField = new AddressField('organisation-address--town-or-city', errorSummarySection)
    this.countyField = new AddressField('organisation-address--county', errorSummarySection)
  }

  toggleVisability = (state: StateToView) => {
    const isShown = state == StateToView.enterAddress

    this.$enterAddressSection.toggleClass('govuk-visually-hidden', !isShown)

    this.addressLine1Field.toggleVisability(isShown)
    this.addressLine2Field.toggleVisability(isShown)
    this.townOrCityField.toggleVisability(isShown)
    this.countyField.toggleVisability(isShown)

  }

  focus = () => {
    this.addressLine1Field.focus()
  }

  setAddress = (addressResult: AddressResult) => {
    this.addressLine1Field.val(addressResult.address_line_1)
    this.addressLine2Field.val(addressResult.address_line_2)
    this.townOrCityField.val(addressResult.address_town)
    this.countyField.val('')
  }

  clearAddress = () => {
    this.addressLine1Field.val('')
    this.addressLine2Field.val('')
    this.townOrCityField.val('')
    this.countyField.val('')
  }

  isAddressFilledIn = () => {
    return [
      this.addressLine1Field.val() ?? '',
      this.addressLine2Field.val() ?? '',
      this.townOrCityField.val() ?? '',
      this.countyField.val() ?? '',
    ].some(value => value !== '')
  }
}

class EnterPostcodeSection implements Section {
  findAddress: FindAddress
  postcodeValue?: string
  $enterPostcodeSection: JQuery<HTMLElement>
  postcodeField: AddressField

  constructor (findAddress: FindAddress, $enterPostcodeSection: JQuery<HTMLElement>, errorSummarySection: ErrorSummarySection) {
    this.findAddress = findAddress
    this.$enterPostcodeSection = $enterPostcodeSection
    this.postcodeField = new AddressField('organisation-address--postcode', errorSummarySection)
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  toggleVisability = (_state: StateToView) => {
    this.$enterPostcodeSection.toggleClass('govuk-visually-hidden', false)
    this.postcodeField.toggleVisability(true)
  }

  focus = () => {
    this.postcodeField.focus()
  }

  validatePostcode = (): boolean => {
    this.postcodeField.clearError()

    const postcodeResult = this.destructurePostCode()

    if (postcodeResult.valid) {
      this.postcodeValue = postcodeResult.fullPostcode
    } else {
      this.postcodeField.showError()
    }

    return postcodeResult.valid
  }

  isPostcodeFilledIn = () => {
    return this.postcodeField.val() ?? '' !== ''
  }

  private destructurePostCode (): PostcodeResult {
    const input: string = String(this.postcodeField.val() ?? '').trim().toUpperCase()
    const regEx = /^(([A-Z][A-Z]{0,1})([0-9][A-Z0-9]{0,1})) {0,}(([0-9])([A-Z]{2}))$/i
    const matches: RegExpMatchArray | null = input.match(regEx)

    let result: PostcodeResult = { valid: false, input }

    if (matches !== null) {
      result = {
        ...result,
        valid: true,
        fullPostcode: `${matches[1]} ${matches[4]}`
      }
    }

    return result
  }
}

class FindAddressSection implements Section {
  findAddress: FindAddress
  $findAddressSection: JQuery<HTMLElement>
  $findAddressButton: JQuery<HTMLButtonElement>

  constructor (findAddress: FindAddress, $findAddressSection: JQuery<HTMLElement>) {
    this.findAddress = findAddress
    this.$findAddressSection = $findAddressSection
    this.$findAddressButton = $findAddressSection.find('#organisation-address--find-address-button')
  }

  init = () => {
    this.$findAddressButton.on('click', async (event) => {
      event.preventDefault()

      await this.findAddress.findAddress()
    })
  }

  toggleVisability = (state: StateToView) => {
    const isShown = state == StateToView.postcodeSearch || state == StateToView.selectAddress

    this.$findAddressSection.toggleClass('govuk-visually-hidden', !isShown)

    if (isShown) {
      this.$findAddressButton.removeAttr('tabindex')
    } else {
      this.$findAddressButton.attr('tabindex', '-1')
    }
  }

  focus = () => {
    this.$findAddressButton.trigger('focus')
  }
}

class SelectAddressSection implements Section {
  findAddress: FindAddress
  $selectAddressSection: JQuery<HTMLElement>
  $selectAddressField: JQuery<HTMLSelectElement>
  $enterAddressManuallyButton: JQuery<HTMLButtonElement>
  promptText: {singular: string, plural: string}

  constructor (findAddress: FindAddress, $selectAddressSection: JQuery<HTMLElement>) {
    this.findAddress = findAddress
    this.$selectAddressSection = $selectAddressSection
    this.$selectAddressField = $selectAddressSection.find('.organisation-address--select-address')
    this.$enterAddressManuallyButton = $selectAddressSection.find('#organisation-address--enter-address-manually-button')
    this.promptText = {
      singular: this.$selectAddressField.data('promptSingular'),
      plural: this.$selectAddressField.data('promptPlural')
    }
  }

  init = () => {
    this.$selectAddressField.on('change', () => {
      this.findAddress.selectAddress()
    })

    this.$enterAddressManuallyButton.on('click', (event) => {
      event.preventDefault()
      this.findAddress.enterAddressManually()
    })
  }

  toggleVisability = (state: StateToView) => {
    const isShown = state == StateToView.selectAddress

    this.$selectAddressSection.toggleClass('govuk-visually-hidden', !isShown)

    if (isShown) {
      this.$selectAddressField.removeAttr('tabindex')
      this.$enterAddressManuallyButton.removeAttr('tabindex')
    } else {
      this.$selectAddressField.attr('tabindex', '-1')
      this.$enterAddressManuallyButton.attr('tabindex', '-1')
    }
  }

  focus = () => {
    this.$selectAddressField.trigger('focus')
  }

  processResults = (addressResults: AddressResult[]) => {
    this.clearSelection()

    this.getOptions(addressResults).forEach((option: string) => this.$selectAddressField.append(option))
  }

  getSelectedAddress = (): AddressResult => {
    const selectedItem = $(this.$selectAddressField.find('option:selected')).data()

    return {
      summary_line: '',
      address_line_1: selectedItem.addressLine1,
      address_line_2: selectedItem.addressLine2,
      address_town: selectedItem.addressTown,
      address_postcode: selectedItem.addressPostcode
    }
  }

  private  clearSelection = () => {
    this.$selectAddressField.empty()
  }

  private getOptions = (results: AddressResult[]): string[] => {
    return [
      `<option value>${this.getPromptText(results.length)}</option>`,
      ...results.map(result => this.createOption(result))
    ]
  }

  private getPromptText = (number: number) =>  `${number} ${number == 1 ? this.promptText.singular : this.promptText.plural}`

  private createOption = (addressResult: AddressResult): string => {
    return `
      <option
        value="${addressResult.summary_line}"
        data-address-line1="${addressResult.address_line_1}"
        data-address-line2="${addressResult.address_line_2}"
        data-address-town="${addressResult.address_town}"
        data-address-postcode="${addressResult.address_postcode}"
      >${addressResult.summary_line}</option>
    `
  }
}

class ChangeAddressSection implements Section {
  findAddress: FindAddress
  $changeAddressSection: JQuery<HTMLElement>
  $changeAddressButton: JQuery<HTMLButtonElement>

  constructor (findAddress: FindAddress, $changeAddressSection: JQuery<HTMLElement>) {
    this.findAddress = findAddress
    this.$changeAddressSection = $changeAddressSection
    this.$changeAddressButton = $changeAddressSection.find('#organisation-address--change-address-button')
  }

  init = () => {
    this.$changeAddressButton.on('click', (event) => {
      event.preventDefault()

      this.findAddress.changeAddress()
    })
  }

  toggleVisability = (state: StateToView) => {
    const isShown = state == StateToView.enterAddress

    this.$changeAddressSection.toggleClass('govuk-visually-hidden', !isShown)

    if (isShown) {
      this.$changeAddressButton.removeAttr('tabindex')
    } else {
      this.$changeAddressButton.attr('tabindex', '-1')
    }
  }

  focus = () => {
    this.$changeAddressButton.trigger('focus')
  }
}

class FindAddress {
  errorSummarySection: ErrorSummarySection
  enterAddressSection: EnterAddressSection
  enterPostcodeSection: EnterPostcodeSection
  findAddressSection: FindAddressSection
  selectAddressSection: SelectAddressSection
  changeAddressSection: ChangeAddressSection

  constructor (findAddressFieldset: JQuery<HTMLFieldSetElement>) {
    this.errorSummarySection = new ErrorSummarySection()
    this.enterAddressSection = new EnterAddressSection(this, findAddressFieldset.find('#organisation-address--enter-address'), this.errorSummarySection)
    this.enterPostcodeSection = new EnterPostcodeSection(this, findAddressFieldset.find('#organisation-address--enter-postcode'), this.errorSummarySection)
    this.findAddressSection = new FindAddressSection(this, findAddressFieldset.find('#organisation-address--find-address'))
    this.selectAddressSection = new SelectAddressSection(this, findAddressFieldset.find('#organisation-address--select-address'))
    this.changeAddressSection = new ChangeAddressSection(this, findAddressFieldset.find('#organisation-address--change-address'))
  }

  init = () => {
    this.updateView(this.isAddressFilledIn() ? StateToView.enterAddress : StateToView.postcodeSearch)

    this.findAddressSection.init()
    this.selectAddressSection.init()
    this.changeAddressSection.init()
  }

  updateView = (state: StateToView) => {
    this.enterAddressSection.toggleVisability(state)
    this.enterPostcodeSection.toggleVisability(state)
    this.findAddressSection.toggleVisability(state)
    this.selectAddressSection.toggleVisability(state)
    this.changeAddressSection.toggleVisability(state)
    this.updateFocus(state)
  }

  updateFocus = (state:StateToView) => {
    switch (state) {
      case StateToView.postcodeSearch:
        this.enterPostcodeSection.focus()
        break
      case StateToView.selectAddress:
        this.selectAddressSection.focus()
        break
      case StateToView.enterAddress:
        this.enterAddressSection.focus()
        break
    }
  }

  isAddressFilledIn = () => {
    return this.enterAddressSection.isAddressFilledIn() || this.enterPostcodeSection.isPostcodeFilledIn()
  }

  findAddress = async () => {
    if (this.enterPostcodeSection.validatePostcode()) {
      const addressResults = await this.callAPI()
      this.selectAddressSection.processResults(addressResults)
      this.updateView(StateToView.selectAddress)
    }
  }

  selectAddress = () => {
    this.enterAddressSection.setAddress(this.selectAddressSection.getSelectedAddress())
    this.updateView(StateToView.enterAddress)
  }

  enterAddressManually = () => {
    this.updateView(StateToView.enterAddress)
  }

  changeAddress = () => {
    this.enterAddressSection.clearAddress()
    this.enterPostcodeSection.postcodeField.clearError()
    this.updateView(StateToView.postcodeSearch)
  }

  callAPI = async (): Promise<AddressResult[]> => {
    let result: AddressResult[] = []
  
    try {
      const response = await get(
        encodeURI(`/api/v2/postcodes/${this.enterPostcodeSection.postcodeValue}`),
        {
          responseKind: 'json',
        }
      )
    
      if (response.ok) {
        const data = await response.json
   
        result = data.result ?? []
      }
    } catch {
      // Do nothing
    }

    return result
  }
}

const initFindAddress = (): void => {
  if ($('[data-module="organisation-address--find-address"]').length) new FindAddress($('[data-module="organisation-address--find-address"]')).init()
}

export default initFindAddress
