interface NestedAttributesFieldsArguments {
  $button: JQuery<HTMLAnchorElement>
  nestedAttributeRowClasses: NestedAttributeRowClasses
  rowLabelText: string
  removeButtonMode: RemoveButtonModes
}

interface NestedAttributeRowClasses {
  rowClass: string
  rowNumberClass: string
  removeButtonClass: string
  destroyRowClass: string
}

type RemoveButtonModes = 'all' | 'final'

type NestedAttributeRowArguments = {
  initiateRow: {
    $row: JQuery<HTMLElement>
  }
  generateRowHTML?: never
} | {
  initiateRow?: never
  generateRowHTML: {
    fields: string
    id: string
  }
}

interface NestedAttributeRowInterface {
  updateRowLabelText: (text: string) => void
  toggleRemoveButton: (isShown: boolean) => void
}

interface AddNestedAttributeButtonInterface {
  updateButtonText: (numberOfItems: number) => void
}

interface NestedAttributesFieldsInterface {
  updateAll: () => void
  addNestedAttributeRow: (nestedAttributeRowArguments: NestedAttributeRowArguments) => void
  removeNestedAttributeRow: (nestedAttributeRowToRemove: NestedAttributeRow) => void
}

class NestedAttributeRow implements NestedAttributeRowInterface {
  private readonly $row: JQuery<HTMLElement>
  private readonly $rowLabel: JQuery<HTMLLabelElement>
  private readonly $rowRemoveButton: JQuery<HTMLAnchorElement>
  private readonly $destoryRowInput: JQuery<HTMLInputElement>

  constructor (nestedAttributesFields: NestedAttributesFields, nestedAttributeRowClasses: NestedAttributeRowClasses, nestedAttributeRowArguments: NestedAttributeRowArguments) {
    if (nestedAttributeRowArguments.initiateRow !== undefined) {
      this.$row = nestedAttributeRowArguments.initiateRow.$row
    } else {
      const time = new Date().getTime()
      const regexp = new RegExp(nestedAttributeRowArguments.generateRowHTML.id, 'g')

      this.$row = $(nestedAttributeRowArguments.generateRowHTML.fields.replace(regexp, String(time)))
    }

    this.$rowLabel = this.$row.find(`.${nestedAttributeRowClasses.rowNumberClass}`) as JQuery<HTMLLabelElement>
    this.$rowRemoveButton = this.$row.find(`.${nestedAttributeRowClasses.removeButtonClass}`) as JQuery<HTMLAnchorElement>
    this.$destoryRowInput = this.$row.find(`.${nestedAttributeRowClasses.destroyRowClass}`) as JQuery<HTMLInputElement>

    if (nestedAttributeRowArguments.generateRowHTML !== undefined) {
      const updatedFields: HTMLElement | undefined = this.$row.get(0)

      if (updatedFields !== undefined) $('.fields').append(updatedFields)
    }

    this.setEventListeners(nestedAttributesFields)
  }

  private readonly setEventListeners = (nestedAttributesFields: NestedAttributesFields): void => {
    this.$rowRemoveButton.on('click', (event: JQuery.ClickEvent) => {
      event.preventDefault()
      this.$destoryRowInput.val('true')
      this.$row.hide()
      this.$row.removeClass()
      this.$rowRemoveButton.off()

      nestedAttributesFields.removeNestedAttributeRow(this)

      nestedAttributesFields.updateAll()
    })
  }

  updateRowLabelText = (text: string): void => {
    this.$rowLabel.text(text)
  }

  toggleRemoveButton = (isShown: boolean): void => {
    isShown ? this.$rowRemoveButton.show() : this.$rowRemoveButton.hide()
  }
}

class AddNestedAttributeButton implements AddNestedAttributeButtonInterface {
  private readonly $button: JQuery<HTMLAnchorElement>
  private readonly id: string
  private readonly fields: string
  private readonly buttonText: string

  constructor ($button: JQuery<HTMLAnchorElement>, nestedAttributesFields: NestedAttributesFields) {
    this.$button = $button
    this.id = $button.data('id')
    this.fields = $button.data('fields')
    this.buttonText = $button.data('button-text')
    this.setEventListeners(nestedAttributesFields)
  }

  private readonly setEventListeners = (nestedAttributesFields: NestedAttributesFields): void => {
    this.$button.on('click', (event: JQuery.ClickEvent) => {
      event.preventDefault()

      nestedAttributesFields.addNestedAttributeRow({
        generateRowHTML: {
          fields: this.fields,
          id: this.id
        }
      })

      nestedAttributesFields.updateAll()
    })
  }

  updateButtonText = (numberOfItems: number): void => {
    this.$button.text(this.buttonText.replace('<number_of_items>', String(numberOfItems)))
  }
}

class NestedAttributesFields implements NestedAttributesFieldsInterface {
  private readonly maxNumberOfItems = 99
  private readonly addNestedAttributeButton: AddNestedAttributeButton
  private nestedAttributeRows: NestedAttributeRow[] = []
  private readonly nestedAttributeRowClasses: NestedAttributeRowClasses
  private readonly rowLabelText: string
  private readonly removeButtonMode: RemoveButtonModes

  constructor (nestedAttributesFieldsArguments: NestedAttributesFieldsArguments) {
    this.addNestedAttributeButton = new AddNestedAttributeButton(nestedAttributesFieldsArguments.$button, this)
    this.nestedAttributeRowClasses = nestedAttributesFieldsArguments.nestedAttributeRowClasses
    this.rowLabelText = nestedAttributesFieldsArguments.rowLabelText
    this.removeButtonMode = nestedAttributesFieldsArguments.removeButtonMode

    $(`.${nestedAttributesFieldsArguments.nestedAttributeRowClasses.rowClass}`).each((_index: number, row: HTMLElement) => {
      this.addNestedAttributeRow({
        initiateRow: {
          $row: $(row)
        }
      })
    })

    this.updateAll()
  }

  private readonly getNumberOfRows = (): number => this.nestedAttributeRows.length

  private readonly updateRowAndButtonNumbers = (): void => {
    this.nestedAttributeRows.forEach((nestedAttributeRow: NestedAttributeRow, index: number) => { nestedAttributeRow.updateRowLabelText(`${this.rowLabelText} ${index + 1}`) })
    this.addNestedAttributeButton.updateButtonText(this.maxNumberOfItems - this.getNumberOfRows())
  }

  private readonly updateRemoveButtonVisibilities = (): void => {
    if (this.removeButtonMode === 'all') {
      this.nestedAttributeRows.forEach((nestedAttributeRow: NestedAttributeRow) => { nestedAttributeRow.toggleRemoveButton(this.getNumberOfRows() > 1) })
    } else {
      this.nestedAttributeRows.forEach((nestedAttributeRow: NestedAttributeRow, index: number) => { nestedAttributeRow.toggleRemoveButton(index > 0 && index + 1 === this.getNumberOfRows()) })
    }
  }

  updateAll = (): void => {
    this.updateRemoveButtonVisibilities()
    this.updateRowAndButtonNumbers()
  }

  addNestedAttributeRow = (nestedAttributeRowArguments: NestedAttributeRowArguments): void => {
    if (this.getNumberOfRows() < this.maxNumberOfItems) this.nestedAttributeRows.push(new NestedAttributeRow(this, this.nestedAttributeRowClasses, nestedAttributeRowArguments))
  }

  removeNestedAttributeRow = (nestedAttributeRowToRemove: NestedAttributeRow): void => {
    this.nestedAttributeRows = this.nestedAttributeRows.filter((nestedAttributeRow: NestedAttributeRow) => nestedAttributeRow !== nestedAttributeRowToRemove)
  }
}

const initNestedAttributesFields = (): void => {
  const pensionFund: NestedAttributesFieldsArguments = {
    $button: $('.add-pension-button'),
    nestedAttributeRowClasses: {
      rowClass: 'pension-row',
      rowNumberClass: 'pension-number',
      removeButtonClass: 'remove-pension-record',
      destroyRowClass: 'pension-destroy-box'
    },
    rowLabelText: 'Pension fund name',
    removeButtonMode: 'all'
  }

  const lifts: NestedAttributesFieldsArguments = {
    $button: $('.add-lift-button'),
    nestedAttributeRowClasses: {
      rowClass: 'lift-row',
      rowNumberClass: 'lift-number',
      removeButtonClass: 'remove-lift-record',
      destroyRowClass: 'lift-destroy-box'
    },
    rowLabelText: 'Lift',
    removeButtonMode: 'final'
  }

  if (pensionFund.$button.length > 0) new NestedAttributesFields(pensionFund)
  if (lifts.$button.length > 0) new NestedAttributesFields(lifts)
}

export default initNestedAttributesFields
