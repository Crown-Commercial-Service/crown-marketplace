const enableRadios = (detailsOpen: boolean) => {
  const $radioInputs: JQuery<HTMLElement> = $('.govuk-details__text .govuk-radios__item')

  if (detailsOpen === true) {
    $radioInputs.each((_, element: HTMLElement) => {
      $(element).find('input').removeAttr('disabled')
    })
  } else {
    $radioInputs.each((_, element: HTMLElement) => {
      $(element).find('input').attr('disabled', 'disabled')
    })
  }
}

const initBuildingType = (): void => {
  if ($('.building-type').length) {
    const $govukDetails: JQuery<HTMLDetailsElement> = $('.govuk-details')

    $govukDetails.on('toggle', (event: JQuery.TriggeredEvent) => {
      enableRadios($(event.currentTarget).attr('open') === 'open')
    })
  }
}

export default initBuildingType
