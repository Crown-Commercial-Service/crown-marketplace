interface HeaderInterface {
  $menuButton: JQuery<HTMLButtonElement>
  $menu: JQuery<HTMLElement>
}

class Header implements HeaderInterface {
  $menuButton: JQuery<HTMLButtonElement>
  $menu: JQuery<HTMLElement>

  constructor () {
    this.$menuButton = $('.ccs-js-header-toggle')
    this.$menu = $(`#${this.$menuButton.attr('aria-controls') as string}`)

    this.syncState(this.$menu.hasClass('ccs-header__navigation-lists--open'))
    this.setEventListeners()
  }

  private readonly syncState = (isVisible: boolean): void => {
    this.$menuButton.toggleClass('ccs-header__menu-button--open', isVisible)
    this.$menuButton.attr('aria-expanded', String(isVisible))
  }

  private readonly setEventListeners = (): void => {
    this.$menuButton.on('click', () => {
      this.$menu.toggleClass('ccs-header__navigation-lists--open')

      this.syncState(this.$menu.hasClass('ccs-header__navigation-lists--open'))
    })
  }
}

const initHeader = (): void => {
  if ($('[data-module="ccs-header"]').length) new Header()
}

export default initHeader
