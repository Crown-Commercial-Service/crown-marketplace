import Cookies from 'js-cookie'
import { CookiePreferences } from './cookieBanner'

enum GrantType {
  GRANTED = 'granted',
  NOT_GRANTED = 'not granted'
}

declare global {
  interface Window {
    dataLayer: {
      push: (data: {
        event: 'gtm_consent_update',
        usage_consent: GrantType,
        glassbox_consent: GrantType,
        marketing_consent: GrantType
      }) => void
    }
  }
}


const getCookiePreferences = (): string => Cookies.get('cookie_preferences_cmp') ?? '{}'

const getCookiePreferencesSaved = (): string => Cookies.get('cookie_preferences_cmp_saved') ?? '{}'

const setCookiePreferencesSaved = (cookiePreferences: CookiePreferences) => {
  Cookies.set('cookie_preferences_cmp_saved', JSON.stringify(cookiePreferences), { expires: 365 })
}

const getGrantedText = (state: boolean) => state ? GrantType.GRANTED : GrantType.NOT_GRANTED

const updateDataLayer = (cookiePreferences: CookiePreferences) => {
  window.dataLayer.push({
    event: 'gtm_consent_update',
    usage_consent: getGrantedText(cookiePreferences.usage),
    glassbox_consent: getGrantedText(cookiePreferences.glassbox),
    marketing_consent: GrantType.NOT_GRANTED
  })

  setCookiePreferencesSaved(cookiePreferences)
}

const initGoogleAnalyticsDataLayer = () => {
  if (window.dataLayer) {
    const cookiePreferences = getCookiePreferences()
    const cookiePreferencesSaved = getCookiePreferencesSaved()

    if (cookiePreferences !== cookiePreferencesSaved) {
      updateDataLayer(JSON.parse(cookiePreferences))
    }
  }
}

export default initGoogleAnalyticsDataLayer
