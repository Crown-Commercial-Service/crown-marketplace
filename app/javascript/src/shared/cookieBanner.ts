import * as Cookies from 'js-cookie'

type CookieBannerFormData = Record<string, string>

interface CookiePreferences {
  settings_viewed: boolean
  google_analytics_enabled: boolean
  glassbox_enabled: boolean
}

interface CookieUpdateOption {
  cookieName: keyof CookiePreferences
  cookiePrefixes: string[]
}

const cookieUpdateOptions: CookieUpdateOption[] = [
  {
    cookieName: 'google_analytics_enabled',
    cookiePrefixes: ['_ga', '_gi']
  },
  {
    cookieName: 'glassbox_enabled',
    cookiePrefixes: ['_cls']
  }
]

const getCookiePreferences = (): CookiePreferences => {
  const defaultCookieSettings = '{"google_analytics_enabled":true,"glassbox_enabled":false}'

  return JSON.parse(Cookies.get('crown_marketplace_cookie_options_v1') ?? defaultCookieSettings)
}

const removeUnwantedCookies = (): void => {
  const cookieList: string[] = Object.keys(Cookies.get())
  const cookiesToRemove: string[] = ['crown_marketplace_cookie_settings_viewed', 'crown_marketplace_google_analytics_enabled']
  const cookiePreferences: CookiePreferences = getCookiePreferences()
  const cookiePrefixes: string[] = []

  cookieUpdateOptions.forEach((cookieUpdateOption) => {
    if (!cookiePreferences[cookieUpdateOption.cookieName]) cookiePrefixes.push(...cookieUpdateOption.cookiePrefixes)
  })

  for (let i = 0; i < cookieList.length; i++) {
    const cookieName = cookieList[i]

    if (cookiePrefixes.some((cookiePrefix) => cookieName.startsWith(cookiePrefix))) cookiesToRemove.push(cookieName)
  }

  cookiesToRemove.forEach((cookieName) => { Cookies.remove(cookieName, { path: '/', domain: '.crowncommercial.gov.uk' }) })
}

const removeGACookies = (cookieBannerFormData: CookieBannerFormData, successFunction: () => void, failureFunction: () => void): void => {
  let success = false

  $.ajax({
    type: 'PUT',
    url: '/api/v2/update-cookie-settings',
    data: cookieBannerFormData,
    dataType: 'json',
    success () {
      success = true
    },
    error () {
      success = false
    },
    complete () {
      success ? successFunction() : failureFunction()
    }
  }).catch(() => {
    failureFunction()
  })
}

const scrollNotificationBannerIntoView = ($notificationBanner: JQuery<HTMLElement>, $otherNotificationBanner: JQuery<HTMLElement>): void => {
  $otherNotificationBanner.hide()
  $notificationBanner.show()

  const offsetCoordinates = $notificationBanner.offset()

  if (offsetCoordinates !== undefined) {
    $('html, body').animate({ scrollTop: offsetCoordinates.top }, 'slow')
  }
}

const cookiesSaved = (): void => {
  scrollNotificationBannerIntoView(
    $('#cookie-settings-saved'),
    $('#cookie-settings-not-saved')
  )
}

const cookiesNotSaved = (): void => {
  scrollNotificationBannerIntoView(
    $('#cookie-settings-not-saved'),
    $('#cookie-settings-saved')
  )
}

const cookieSettingsViewed = ($newBanner: JQuery<HTMLElement>): void => {
  $('#cookie-options-container').hide()
  $newBanner.show()
}

const cookieSettingsError = (): void => {
  $('#cookie-settings-not-saved').show()
}

const updateBanner = (isAccepeted: string, $newBanner: JQuery<HTMLElement>): void => {
  removeGACookies(
    {
      ga_cookie_usage: isAccepeted,
      glassbox_cookie_usage: isAccepeted
    },
    cookieSettingsViewed.bind(null, $newBanner),
    cookieSettingsError
  )
}

const initCookieBanner = (): void => {
  removeUnwantedCookies()

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
      cookiesNotSaved
    )
  })
}

export default initCookieBanner
