interface GOVUKStepByStepNavStepSectionInterface {
  toggleSection(isShown: boolean): void
}

interface GOVUKStepByStepNavStepInterface {
  toggleOnClick: (event: JQuery.ClickEvent) => void
  isShown: () => boolean
  toggleSection: (isShown: boolean) => void
}

interface GOVUKStepByStepNavInterface {
  prependAndCreateShowHideAllButton: (showHideAllButtonHTML: string) => JQuery<HTMLButtonElement>
  toggleAllOnClick: (event: JQuery.ClickEvent) => void
  checkIfAllShown: () => void
}

class GOVUKStepByStepNavShowHideAllButton {
  private govukStepByStepNav: GOVUKStepByStepNav
  private showAllText: string
  private hideAllText: string
  private $showHideAllButton: JQuery<HTMLButtonElement>
  private $showHideAllButtonnChevron: JQuery<HTMLSpanElement>
  private $showHideAllButtonTextSpan: JQuery<HTMLSpanElement>

  constructor(govukStepByStepNav: GOVUKStepByStepNav, showAllText: string, hideAllText: string) {
    this.govukStepByStepNav = govukStepByStepNav
    this.showAllText = showAllText
    this.hideAllText = hideAllText

    this.$showHideAllButton = govukStepByStepNav.prependAndCreateShowHideAllButton(this.generateButtonHTML())
    this.$showHideAllButtonnChevron = this.$showHideAllButton.find('.gem-c-step-nav__chevron')
    this.$showHideAllButtonTextSpan = this.$showHideAllButton.find('.gem-c-step-nav__button-text')

    this.setEventListener()
  }

  private generateButtonHTML = (): string => {
    return `
    <button type="button" aria-expanded="false" class="gem-c-step-nav__button gem-c-step-nav__button--controls js-step-controls-button">
      <span class="gem-c-step-nav__chevron gem-c-step-nav__chevron--down js-step-controls-button-icon"></span>
      <span class="gem-c-step-nav__button-text gem-c-step-nav__button-text--all js-step-controls-button-text">${this.showAllText}</span>
    </button>
    `
  }

  private setEventListener = (): void => {
    this.$showHideAllButton.on('click', this.govukStepByStepNav.toggleAllOnClick.bind(this))
  }

  toggleShowHideAll = (showAll: boolean): void => {
    if(showAll) {
      this.$showHideAllButtonnChevron.removeClass('gem-c-step-nav__chevron--down')
      this.$showHideAllButtonTextSpan.text(this.hideAllText)
    } else {
      this.$showHideAllButtonnChevron.addClass('gem-c-step-nav__chevron--down')
      this.$showHideAllButtonTextSpan.text(this.showAllText)
    }

    this.$showHideAllButton.attr('aria-expanded', String(showAll))
  }
}

class GOVUKStepByStepNavStepShowHideButton implements GOVUKStepByStepNavStepSectionInterface {
  private govukStepByStepNavStep: GOVUKStepByStepNavStep
  private showText: string
  private hideText: string
  private $button: JQuery<HTMLButtonElement>
  private $buttonChevron: JQuery<HTMLSpanElement>
  private $buttonTextSpan: JQuery<HTMLSpanElement>

  constructor (govukStepByStepNavStep: GOVUKStepByStepNavStep, showText: string, hideText: string, $titleSection: JQuery<HTMLSpanElement>, controlledPanel: string) {
    this.govukStepByStepNavStep = govukStepByStepNavStep
    this.showText = showText
    this.hideText = hideText

    const titleText: string = $titleSection.find('.js-step-title-text').text()

    $titleSection.html(this.generateButtonHTML(titleText, controlledPanel))

    this.$button = $titleSection.find('button')
    this.$buttonChevron = this.$button.find('.gem-c-step-nav__chevron')
    this.$buttonTextSpan = this.$button.find('.gem-c-step-nav__button-text')

    this.setEventListener()
  }

  private generateButtonHTML = (titleText: string, controlledPanel: string): string => {
    return `
      <button type="button" class="gem-c-step-nav__button gem-c-step-nav__button--title js-step-title-button" aria-expanded="false" aria-controls="${controlledPanel}">
        <span class="gem-c-step-nav____title-text-focus">
          <span class="gem-c-step-nav__title-text js-step-title-text">${titleText}</span>
          <span class="govuk-visually-hidden gem-c-step-nav__section-heading-divider">, </span>
        </span>
        <span class="gem-c-step-nav__toggle-link js-toggle-link govuk-!-display-none-print">
          <span class="gem-c-step-nav__toggle-link-focus">
            <span class="gem-c-step-nav__chevron js-toggle-link-icon gem-c-step-nav__chevron--down"></span>
            <span class="gem-c-step-nav__button-text js-toggle-link-text">${this.showText}</span>
          </span>
          <span class="govuk-visually-hidden"> this section</span>
        </span
      </button>
    `
  }

  private setEventListener = (): void => {
    this.$button.on('click', this.govukStepByStepNavStep.toggleOnClick.bind(this))
  }

  toggleSection = (isShown: boolean) => {
    if(isShown) {
      this.$buttonChevron.removeClass('gem-c-step-nav__chevron--down')
      this.$buttonTextSpan.text(this.hideText)
    } else {
      this.$buttonChevron.addClass('gem-c-step-nav__chevron--down')
      this.$buttonTextSpan.text(this.showText)
    }

    this.$button.attr('aria-expanded', String(isShown))
  }
}

class GOVUKStepByStepNavStepPanel implements GOVUKStepByStepNavStepSectionInterface {
  private $stepByStepNavigationStepPannel: JQuery<HTMLElement>

  constructor ($stepByStepNavigationStepPannel: JQuery<HTMLElement>) {
    this.$stepByStepNavigationStepPannel = $stepByStepNavigationStepPannel
  }

  toggleSection = (isShown: boolean): void => {
    if (isShown) {
      this.$stepByStepNavigationStepPannel.removeClass('js-hidden')
    } else {
      this.$stepByStepNavigationStepPannel.addClass('js-hidden')
    }
  }
}

class GOVUKStepByStepNavStep implements GOVUKStepByStepNavStepInterface {
  private govukStepByStepNav: GOVUKStepByStepNav
  private $stepByStepNavigationStep: JQuery<HTMLElement>
  private showHideButton: GOVUKStepByStepNavStepShowHideButton
  private stepByStepNavigationStepPannel: GOVUKStepByStepNavStepPanel

  constructor(govukStepByStepNav: GOVUKStepByStepNav, $stepByStepNavigationStep: JQuery<HTMLElement>, showText: string, hideText: string) {
    this.govukStepByStepNav = govukStepByStepNav
    this.$stepByStepNavigationStep = $stepByStepNavigationStep

    const $stepByStepNavigationStepPannel: JQuery<HTMLElement> = $stepByStepNavigationStep.find('.gem-c-step-nav__panel')

    this.showHideButton = new GOVUKStepByStepNavStepShowHideButton(
      this,
      showText,
      hideText,
      $stepByStepNavigationStep.find('.js-step-title'),
      $stepByStepNavigationStepPannel.attr('id') || ''
    )

    this.stepByStepNavigationStepPannel = new GOVUKStepByStepNavStepPanel(
      $stepByStepNavigationStepPannel
    )

    this.toggleSection(false)
  }

  toggleOnClick = (event: JQuery.ClickEvent) => {
    event.preventDefault()

    this.toggleSection(!this.isShown())
  }

  isShown = (): boolean => this.$stepByStepNavigationStep.hasClass('step-is-shown')

  toggleSection = (isShown: boolean): void => {
    if (isShown) {
      this.$stepByStepNavigationStep.addClass('step-is-shown')
    } else {
      this.$stepByStepNavigationStep.removeClass('step-is-shown')
    }

    this.showHideButton.toggleSection(isShown)
    this.stepByStepNavigationStepPannel.toggleSection(isShown)

    this.govukStepByStepNav.checkIfAllShown()
  }
}

class GOVUKStepByStepNav implements GOVUKStepByStepNavInterface {
  private $stepByStepNavigation: JQuery<HTMLElement> = $('#step-by-step-navigation')
  private stepByStepNavigationSteps: GOVUKStepByStepNavStep[] = []
  private stepNavShowHideAllButton: GOVUKStepByStepNavShowHideAllButton

  constructor() {
    const showText: string = this.$stepByStepNavigation.data('show-text')
    const hideText: string = this.$stepByStepNavigation.data('hide-text')
    const showAllText: string = this.$stepByStepNavigation.data('show-all-text')
    const hideAllText: string = this.$stepByStepNavigation.data('hide-all-text')

    this.stepNavShowHideAllButton = new GOVUKStepByStepNavShowHideAllButton(this, showAllText, hideAllText)

    $('.gem-c-step-nav__step').each((_index: number, stepByStepNavigationStep) => {
      this.stepByStepNavigationSteps.push(new GOVUKStepByStepNavStep(this, $(stepByStepNavigationStep), showText, hideText))
    })
  }

  prependAndCreateShowHideAllButton = (showHideAllButtonHTML: string): JQuery<HTMLButtonElement> => {
    this.$stepByStepNavigation.prepend(`<div class="gem-c-step-nav__controls govuk-!-display-none-print">${showHideAllButtonHTML}</div>`)

    return this.$stepByStepNavigation.find('div > button') as JQuery<HTMLButtonElement>
  }

  toggleAllOnClick = (event: JQuery.ClickEvent) => {
    event.preventDefault()

    this.toggleAll(!this.isAllShown())
  }

  private isAllShown = () => this.stepByStepNavigationSteps.every((stepByStepNavigationStep) => stepByStepNavigationStep.isShown())

  private toggleAll = (showAll: boolean): void => {
    this.stepByStepNavigationSteps.forEach((stepByStepNavigationStep) => stepByStepNavigationStep.toggleSection(showAll))
    this.stepNavShowHideAllButton.toggleShowHideAll(showAll)
  }

  checkIfAllShown = (): void => this.stepNavShowHideAllButton.toggleShowHideAll(this.isAllShown())
}

const initStepByStepNav = () => {
  if ($('#step-by-step-navigation').length) new GOVUKStepByStepNav()
}

export default initStepByStepNav
