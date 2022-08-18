const removeGACookies = () => {
  const cookieList = Object.keys(Cookies.get());
  const gaCookieList = [];
  const cookiePrefixes = ['_ga', '_gi', '_cls'];

  for (let i = 0; i < cookieList.length; i++) {
    const cookieName = cookieList[i];

    if (cookiePrefixes.some((cookiePrefix) => cookieName.startsWith(cookiePrefix))) gaCookieList.push(cookieName);
  }

  gaCookieList.forEach((cookieName) => Cookies.remove(cookieName, { path: '/', domain: '.crowncommercial.gov.uk' }));
};

const updateBanner = (isAccepeted, $newBanner) => {
  Cookies.set('crown_marketplace_cookie_settings_viewed', 'true', { expires: 365 });
  Cookies.set('crown_marketplace_google_analytics_enabled', isAccepeted, { expires: 365 });
  $('#cookie-options-container').hide();
  $newBanner.show();
};

document.addEventListener('DOMContentLoaded', () => {
  if (Cookies.get('crown_marketplace_cookie_settings_viewed') === 'true') $('#cookie-consent-container').hide();
  if (Cookies.get('crown_marketplace_google_analytics_enabled') !== 'true') removeGACookies();
});

$(() => {
  $('#accept-cookies').on('click', (e) => {
    e.preventDefault();

    updateBanner('true', $('#cookies-accepted-container'));
  });

  $('#reject-cookies').on('click', (e) => {
    e.preventDefault();

    updateBanner('false', $('#cookies-rejected-container'));
  });

  $('#update-cookie-setings').on('submit', (event) => {
    event.preventDefault();

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
