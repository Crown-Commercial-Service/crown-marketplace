const showAndHideElements = ($elementToShow: JQuery<HTMLElement>, $elementToHide: JQuery<HTMLElement>) => {
  $elementToShow.attr('tabIndex', 0)
  $elementToHide.attr('tabIndex', -1)

  const elementToShow = $elementToShow.get(0)
  if(elementToShow) elementToShow.focus()
}

const selectRegion = ($regionDropDown: JQuery<HTMLSelectElement>, $changeRegion: JQuery<HTMLButtonElement>): void => {
  const selectedRegionText = $regionDropDown.find(':selected').text()

  if (selectedRegionText) {
    showAndHideElements($changeRegion, $regionDropDown)

    $('.govuk-error-summary').hide()
    $('#address_region-error').hide()
    $('#address_region-form-group').removeClass('govuk-form-group--error')
    $('#building-region').text(selectedRegionText)
    $('#select-region').hide()
    $('#region-selection').show()
  }
}

const changeRegion = ($regionDropDown: JQuery<HTMLSelectElement>, $changeRegion: JQuery<HTMLButtonElement>): void => {
  showAndHideElements($regionDropDown, $changeRegion)

  $regionDropDown.prop('selectedIndex', 0)
  $('#region-selection').hide()
  $('#select-region').show()
}

const initSelectRegion = (): void => {
  if ($('#building-missing-region').length < 1) return

  const $regionDropDown: JQuery<HTMLSelectElement> =  $('#facilities_management_building_address_region')
  const $changeRegion: JQuery<HTMLButtonElement> = $('#change-region')

  $regionDropDown.on('change', () => {
    selectRegion($regionDropDown, $changeRegion)
  })

  $changeRegion.on('click', (event: JQuery.ClickEvent) => {
    event.preventDefault()

    changeRegion($regionDropDown, $changeRegion)
  })
}

export default initSelectRegion
