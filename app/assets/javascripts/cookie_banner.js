const removeGACookies = () => {
  const cookieList = Object.keys(Cookies.get());
  const gaCookieList = [];

  for (let i = 0; i < cookieList.length; i++) {
    const cookieName = cookieList[i];

    if (cookieName.startsWith('_ga') || cookieName.startsWith('_gi')) gaCookieList.push(cookieName);
  }

  gaCookieList.forEach((cookieName) => Cookies.remove(cookieName, { path: '/', domain: '.crowncommercial.gov.uk' }));
};

document.addEventListener('DOMContentLoaded', () => {
  if (Cookies.get('crown_marketplace_cookie_settings_viewed') === 'true') $('#cookie-consent-container').hide();
  if (Cookies.get('crown_marketplace_google_analytics_enabled') !== 'true') removeGACookies();
});

$(() => {
  $('#accept-cookies').on('click', (e) => {
    e.preventDefault();

    Cookies.set('crown_marketplace_cookie_settings_viewed', 'true', { expires: 365 });
    Cookies.set('crown_marketplace_google_analytics_enabled', 'true', { expires: 365 });
    $('#cookie-options-container').hide();
    $('#cookies-accepted-container').show();
  });

  $('#reject-cookies').on('click', (e) => {
    e.preventDefault();

    Cookies.set('crown_marketplace_cookie_settings_viewed', 'true', { expires: 365 });
    Cookies.set('crown_marketplace_google_analytics_enabled', 'false', { expires: 365 });
    $('#cookie-options-container').hide();
    $('#cookies-rejected-container').show();
  });

  $('#save-cookie-settings-button').on('click', () => {
    Cookies.set('crown_marketplace_cookie_settings_viewed', 'true', { expires: 365 });

    if ($('input[name=ga_cookie_usage]:checked').val() === 'true') {
      Cookies.set('crown_marketplace_google_analytics_enabled', 'true', { expires: 365 });
    } else {
      Cookies.remove('crown_marketplace_google_analytics_enabled');
      removeGACookies();
    }

    $('#cookie-settings-saved').show();
    $('html, body').animate({ scrollTop: $('#cookie-settings-saved').offset().top }, 'slow');
  });
});
