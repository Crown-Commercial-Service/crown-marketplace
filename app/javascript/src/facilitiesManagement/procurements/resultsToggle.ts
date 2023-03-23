const initResultsToggle = (): void => {
  const $resultsFilterButton: JQuery<HTMLAnchorElement> = $('#results-filter-button')

  $resultsFilterButton.on('click', (event: JQuery.ClickEvent) => {
    event.preventDefault()

    const $requirementsPlane: JQuery<HTMLElement> = $('#requirements-list')
    const $suppliersPlane: JQuery<HTMLElement> = $('#supplier-lot-list__container')

    const isHidden: boolean = $requirementsPlane.is(':hidden')
    const currentText: string = $resultsFilterButton.text()

    if (isHidden) {
      $requirementsPlane.show()
      $suppliersPlane.addClass('govuk-grid-column-two-thirds').removeClass('govuk-grid-column-full')
    } else {
      $requirementsPlane.hide()
      $suppliersPlane.addClass('govuk-grid-column-full').removeClass('govuk-grid-column-two-thirds')
    }

    $resultsFilterButton.text($resultsFilterButton.attr('alt-text') ?? '')
    $resultsFilterButton.attr('alt-text', currentText)
  })
}

export default initResultsToggle
