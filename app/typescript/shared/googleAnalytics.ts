interface Window {
  gaTrackingId: string
}

declare function gtag(config: string, gaTrackingId: string, params: {[key: string]: string|boolean}): void

const cssClassToClickPath: {[key: string]: string} = {
  'ga-crown-logo': 'crown_logo',
  'ga-feedback-mailto': 'feedback',
  'ga-support-mailto': 'support',
  'ga-auth-cognito': 'cognito_login',
  'ga-auth-dfe': 'dfe_login',
  'ga-print-link': 'print',
  'ga-download-shortlist': 'shortlist_download',
  'ga-download-calculator': 'calculator_download'
}

const initGoogleAnalytics = (): void => {
  if (window.gaTrackingId) {
    for (const cssClass in cssClassToClickPath) {
      const $elements: JQuery<HTMLElement> = $(`.${cssClass}`)

      $elements.each((_index: number, $element: HTMLElement) => {
        $($element).on('click', () => {
          const page: string = cssClassToClickPath[cssClass]
          const params: {[key: string]: string|boolean} = {
            anonymize_ip: true,
            page_title: page,
            page_path: `/external/${page}`
          }

          gtag('config', window.gaTrackingId, params)
        })
      })
    }
  }
}

$(() => initGoogleAnalytics())