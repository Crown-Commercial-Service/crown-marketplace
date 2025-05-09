import Cookies from 'js-cookie'
import { put } from '@rails/request.js'

type CookieBannerFormData = Record<string, string>

interface CookiePreferences {
  settings_viewed: boolean
  usage: boolean
  glassbox: boolean
}

interface CookieUpdateOption {
  cookieName: keyof CookiePreferences
  cookiePrefixes: string[]
}

const cookieUpdateOptions: CookieUpdateOption[] = [
  {
    cookieName: 'usage',
    cookiePrefixes: ['_ga', '_gi']
  },
  {
    cookieName: 'glassbox',
    cookiePrefixes: ['_cls']
  }
]

const getCookiePreferences = (): CookiePreferences => {
  const defaultCookieSettings = '{"usage":true,"glassbox":false}'

  return JSON.parse(Cookies.get('cookie_preferences_cmp') ?? defaultCookieSettings)
}

const removeUnwantedCookies = (): void => {
  const cookieList: string[] = Object.keys(Cookies.get())
  const cookiesToRemove: string[] = ['crown_marketplace_cookie_settings_viewed', 'crown_marketplace_google_analytics_enabled', 'crown_marketplace_cookie_options_v1']
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

const removeGACookies = async (cookieBannerFormData: CookieBannerFormData, successFunction: () => void, failureFunction: () => void): Promise<void> => {
  let success = false

  try {
    const response = await put(
      '/api/v2/update-cookie-settings',
      {
        body: JSON.stringify(cookieBannerFormData),
        contentType: 'application/json',
        responseKind: 'json',
      }
    )

    if (response.ok) {
      success = true
    }
  } finally {
    if(success) {
      successFunction()
    } else {
      failureFunction()
    }
  }
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

const updateBanner = async (isAccepeted: string, $newBanner: JQuery<HTMLElement>): Promise<void> => {
  await removeGACookies(
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

  $('[name="cookies"]').on('click', async (event: JQuery.ClickEvent) => {
    event.preventDefault()

    const buttonValue: string = event.currentTarget.value

    await updateBanner(String(buttonValue === 'accept'), $(`#cookies-${buttonValue}ed-container`))
  })

  const $form: JQuery<HTMLFormElement> = $('#update-cookie-setings')

  $form.on('submit', async (event: JQuery.SubmitEvent) => {
    event.preventDefault()

    $('#cookie-settings-saved').show()

    const formData = Object.fromEntries($form.serializeArray().map((element) => [element.name, element.value]))

    await removeGACookies(
      formData,
      cookiesSaved,
      cookiesNotSaved
    )
  })
}

export default initCookieBanner
export { CookiePreferences }
