const toggleLinksInDetails = ($details: JQuery<HTMLDetailsElement>): void => {
  const $detailLinks: JQuery<HTMLElement> = $details.find('a')

  if ($details.attr('open') === 'open') {
    $detailLinks.each((_, element: HTMLElement) => {
      $(element).removeAttr('tabindex')
    })
  } else {
    $detailLinks.each((_, element: HTMLElement) => {
      $(element).attr('tabindex', -1)
    })
  }
}

const initDetailsLinks = (): void => {
  const $govukDetails: JQuery<HTMLDetailsElement> = $('.govuk-details')

  if ($govukDetails.length) {
    $govukDetails.on('toggle', (event: JQuery.TriggeredEvent) => {
      toggleLinksInDetails($(event.currentTarget))
    })
  }
}

export default initDetailsLinks
