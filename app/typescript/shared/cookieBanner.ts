type CookieBannerFormData = {
  [key: string]: string
}

const removeGACookies = (cookieBannerFormData: CookieBannerFormData, successFunction: () => void) => {
  let success = false

  $.ajax({
    type: 'PUT',
    url: '/api/v2/update-cookie-settings',
    data: cookieBannerFormData,
    dataType: 'json',
    success() {
      success = true
    },
    complete() {
      if (success) successFunction()
    },
  })
}

const cookiesSaved = () => {
  const $cookieSettingsSaved: JQuery<HTMLElement> = $('#cookie-settings-saved')

  $cookieSettingsSaved.show()

  const offsetCoordinates = $cookieSettingsSaved.offset()

  if (offsetCoordinates !== undefined) {
    $('html, body').animate({ scrollTop: offsetCoordinates.top }, 'slow')
  }
}

const cookieSettingsViewed = ($newBanner: JQuery<HTMLElement>) => {
  $('#cookie-options-container').hide()
  $newBanner.show()
}

const updateBanner = (isAccepeted: string, $newBanner: JQuery<HTMLElement>) => {
  removeGACookies(
    {
      ga_cookie_usage: isAccepeted,
      glassbox_cookie_usage: isAccepeted,
    },
    cookieSettingsViewed.bind(null, $newBanner),
  )
}

const initCookieBanner = (): void => {
  const obsoleteCookies: string[] = ['crown_marketplace_cookie_settings_viewed', 'crown_marketplace_google_analytics_enabled']

  obsoleteCookies.forEach((cookieName: string) => {
    if (document.cookie.includes(`${cookieName}=`)) document.cookie = `${cookieName}=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;`
  })

  $('[name="cookies"]').on('click', (event: JQuery.ClickEvent) => {
    event.preventDefault()

    const buttonValue: string = event.currentTarget.value

    updateBanner(String(buttonValue === 'accept'), $(`#cookies-${buttonValue}ed-container`))
  })

  const $form: JQuery<HTMLFormElement> = $('#update-cookie-setings')

  $form.on('submit', (event: JQuery.SubmitEvent) => {
    event.preventDefault()

    $('#cookie-settings-saved').show()

    const formData = Object.fromEntries($form.serializeArray().map((element) => [element.name, element.value]))

    removeGACookies(
      formData,
      cookiesSaved,
    )
  })
}

$(() => initCookieBanner())
