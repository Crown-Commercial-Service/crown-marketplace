interface AccordionItemInterface {
  toggleChecked: (isChecked: boolean) => void
}

interface AccordionNamedItemInterface {
  accordionItemDetails: AccordionItemDetails
  isChecked: (isChecked: boolean) => void
}

interface AccordionSectionInterface {
  checkAllSelected: () => void
  toggleCheckAll: (isAllChecked?: boolean) => void
}

interface BasketItemInterface {
  removeBasketItem: () => void
}

interface BasketInterface {
  addItemToBasket: (accordionItemDetails: AccordionNamedItem) => BasketItem
  appendBasketItem: (basketItemHTML: string) => void
  removeBasketItem: () => void
}

interface AccordionItemDetails {
  groupID: string
  itemID: string
  text: string
}

abstract class AccordionItem implements AccordionItemInterface {
  protected $checkBox: JQuery<HTMLInputElement>
  protected accordionSection: AccordionSection
  protected basket: Basket

  constructor (accordionSection: AccordionSection, basket: Basket, $checkBox: JQuery<HTMLInputElement>) {
    this.accordionSection = accordionSection
    this.basket = basket
    this.$checkBox = $checkBox
  }

  abstract toggleChecked (isChecked: boolean): void
  protected abstract setEventListeners (): void
}

class AccordionNamedItem extends AccordionItem implements AccordionNamedItemInterface {
  accordionItemDetails: AccordionItemDetails
  private basketItem?: BasketItem

  constructor (accordionSection: AccordionSection, basket: Basket, $checkBox: JQuery<HTMLInputElement>) {
    super(accordionSection, basket, $checkBox)
    this.accordionItemDetails = {
      groupID: $checkBox.attr('sectionid') ?? '',
      itemID: $checkBox.attr('id') ?? '',
      text: $checkBox.attr('title') ?? ''
    }

    if (this.isChecked() && this.basketItem === undefined) this.basketItem = this.basket.addItemToBasket(this)

    this.setEventListeners()
  }

  toggleChecked = (isChecked: boolean): void => {
    if (isChecked) {
      if (this.basketItem === undefined) this.basketItem = this.basket.addItemToBasket(this)
    } else if (this.basketItem !== undefined) {
      this.basketItem.removeBasketItem()
      delete this.basketItem
    }

    this.$checkBox.prop('checked', isChecked)
    this.accordionSection.checkAllSelected()
  }

  isChecked = (): boolean => this.$checkBox.is(':checked')

  protected setEventListeners = (): void => {
    this.$checkBox.on('click', (): void => { this.toggleChecked(this.isChecked()) })
  }
}

class AccordionSelectAllItem extends AccordionItem {
  constructor (accordionSection: AccordionSection, basket: Basket, $checkBox: JQuery<HTMLInputElement>) {
    super(accordionSection, basket, $checkBox)

    this.setEventListeners()
  }

  protected setEventListeners = (): void => {
    this.$checkBox.on('click', () => { this.accordionSection.toggleCheckAll() })
  }

  toggleChecked = (isChecked: boolean): void => {
    this.$checkBox.prop('checked', isChecked)
  }
}

class AccordionSection implements AccordionSectionInterface {
  private readonly checkBoxes: AccordionNamedItem[] = []
  private readonly numberOfCheckboxes: number
  private readonly selectAllcheckBox: AccordionSelectAllItem

  constructor (basket: Basket, $section: JQuery<HTMLElement>) {
    $section.find('div.govuk-checkboxes__item:not(.ccs-select-all) > input.govuk-checkboxes__input').each((_index: number, checkBox: HTMLElement) => {
      this.checkBoxes.push(new AccordionNamedItem(this, basket, $(checkBox) as JQuery<HTMLInputElement>))
    })

    this.numberOfCheckboxes = this.checkBoxes.length
    this.selectAllcheckBox = new AccordionSelectAllItem(this, basket, $section.find('div.ccs-select-all > input') as JQuery<HTMLInputElement>)
  }

  private readonly numberOfCheckedItems = (): number => this.checkBoxes.filter((accordionItem: AccordionNamedItem): boolean => accordionItem.isChecked()).length

  checkAllSelected = (): void => {
    this.selectAllcheckBox.toggleChecked(this.numberOfCheckboxes === this.numberOfCheckedItems())
  }

  toggleCheckAll = (isAllChecked?: boolean): void => {
    if (isAllChecked === undefined) isAllChecked = this.numberOfCheckboxes > this.numberOfCheckedItems()
    const checkAll = isAllChecked

    this.checkBoxes.forEach((checkBox: AccordionNamedItem) => { checkBox.toggleChecked(checkAll) })
    this.selectAllcheckBox.toggleChecked(checkAll)
  }
}

class BasketItem implements BasketItemInterface {
  private readonly basket: Basket
  private readonly accordionNamedItem: AccordionNamedItem
  private readonly $basketItem: JQuery<HTMLElement>
  private readonly $removeItemLink: JQuery<HTMLAnchorElement>

  constructor (basket: Basket, accordionNamedItem: AccordionNamedItem) {
    this.basket = basket
    this.accordionNamedItem = accordionNamedItem
    basket.appendBasketItem(this.getBasketItemHTML())
    this.$basketItem = $(`#${accordionNamedItem.accordionItemDetails.itemID}_basket`)
    this.$removeItemLink = $(`#${accordionNamedItem.accordionItemDetails.itemID}_removeLink`)
    this.setEventListener()
  }

  private readonly getBasketItemHTML = (): string => {
    const removeLink = `<div style="float:right;"><span class="remove-link"><a id="${this.accordionNamedItem.accordionItemDetails.itemID}_removeLink" groupid="${this.accordionNamedItem.accordionItemDetails.groupID}" name="${this.accordionNamedItem.accordionItemDetails.itemID}_removeLink" href="" class="govuk-link font-size--8">Remove</a></span></div>`
    const itemText = `<div style="float:left; max-width: 70%; float:left; font-size: 1rem;">${this.accordionNamedItem.accordionItemDetails.text}</div>`

    return `<li style="margin-top:0; word-break: keep-all;" groupid="${this.accordionNamedItem.accordionItemDetails.groupID}" class="govuk-list" id="${this.accordionNamedItem.accordionItemDetails.itemID}_basket">${removeLink}${itemText}</li>`
  }

  removeBasketItem = (): void => {
    this.$basketItem.remove()

    this.basket.removeBasketItem()
  }

  private readonly setEventListener = (): void => {
    this.$removeItemLink.on('click', (event: JQuery.ClickEvent) => {
      event.preventDefault()

      this.accordionNamedItem.toggleChecked(false)
    })
  }
}

class Basket implements BasketInterface {
  private readonly $basket: JQuery<HTMLElement> = $('.basket')
  private readonly $itemList: JQuery<HTMLUListElement> = this.$basket.find('ul')
  private readonly $numberOfItems: JQuery<HTMLElement> = this.$basket.find('h3')
  private readonly $removeAllLink: JQuery<HTMLAnchorElement> = this.$basket.find('div > a') as JQuery<HTMLAnchorElement>
  private readonly accordionSections: AccordionSection[] = []

  private readonly textOptions: Record<string, string> = {
    no_items: this.$numberOfItems.data('txt02'),
    single_item: this.$numberOfItems.data('txt03'),
    plural_items: this.$numberOfItems.data('txt01')
  }

  constructor () {
    $('.govuk-accordion__section.chooser-section').each((_index: number, accordionSection: HTMLElement) => {
      this.accordionSections.push(new AccordionSection(this, $(accordionSection)))
    })

    this.updateNumberOfItems()

    this.setEventListeners()
  }

  private readonly numberOfItems = (): number => this.$itemList.find('li').length

  addItemToBasket = (accordionNamedItem: AccordionNamedItem): BasketItem => {
    const basketItem = new BasketItem(this, accordionNamedItem)

    this.updateNumberOfItems()

    return basketItem
  }

  appendBasketItem = (basketItemHTML: string): void => {
    this.$itemList.append(basketItemHTML)
  }

  removeBasketItem = (): void => { this.updateNumberOfItems() }

  private readonly updateNumberOfItems = (): void => {
    const numberOfItems: number = this.numberOfItems()

    let numberOfItemsNumber = String(numberOfItems)
    let numberOfItemsText
    let isShown = true

    if (numberOfItems === 0) {
      numberOfItemsNumber = ''
      numberOfItemsText = this.textOptions.no_items
      isShown = false
    } else if (numberOfItems === 1) {
      numberOfItemsText = this.textOptions.single_item
      isShown = false
    } else {
      numberOfItemsText = this.textOptions.plural_items
    }

    this.$numberOfItems.html(`<span id="selected-items-count">${numberOfItemsNumber}</span> <span>${numberOfItemsText}</span>`)
    this.toggleRemoveAllButton(isShown)
  }

  private readonly toggleRemoveAllButton = (isShown: boolean): void => {
    isShown ? this.$removeAllLink.show() : this.$removeAllLink.hide()
  }

  private readonly removeAll = (event: JQuery.ClickEvent): void => {
    event.preventDefault()

    Object.values(this.accordionSections).forEach((accordionSection) => { accordionSection.toggleCheckAll(false) })

    this.updateNumberOfItems()
  }

  private readonly setEventListeners = (): void => {
    this.$removeAllLink.on('click', (event: JQuery.ClickEvent) => { this.removeAll(event) })
  }
}

const initCheckboxAccordion = (): void => {
  if ($('.govuk-accordion__section.chooser-section').length > 0) new Basket()
}

export default initCheckboxAccordion
