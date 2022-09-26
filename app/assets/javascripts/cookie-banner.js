
const removeGACookies = (formData, successFunction) => {
  let success = false;

  $.ajax({
    type: 'PUT',
    url: '/api/v2/update-cookie-settings',
    data: formData,
    dataType: 'json',
    success() {
      success = true;
    },
    complete() {
      if (success) successFunction();
    },
  });
};

const cookiesSaved = () => {
  $('#cookie-settings-saved').show();
  $('html, body').animate({ scrollTop: $('#cookie-settings-saved').offset().top }, 'slow');
};

const cookieSettingsViewed = ($newBanner) => {
  $('#cookie-options-container').hide();
  $newBanner.show();
};

const updateBanner = (isAccepeted, $newBanner) => {
  removeGACookies(
    {
      ga_cookie_usage: isAccepeted,
      glassbox_cookie_usage: isAccepeted,
    },
    cookieSettingsViewed.bind(null, $newBanner),
  );
};

$(() => {
  const obsoleteCookies = ['crown_marketplace_cookie_settings_viewed', 'crown_marketplace_google_analytics_enabled'];

  obsoleteCookies.forEach((cookieName) => {
    if (document.cookie.includes(`${cookieName}=`)) document.cookie = `${cookieName}=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;`;
  });

  $('[name="cookies"]').on('click', (event) => {
    event.preventDefault();

    const buttonValue = event.currentTarget.value;

    updateBanner(buttonValue === 'accept', $(`#cookies-${buttonValue}ed-container`));
  });

  const $form = $('#update-cookie-setings');

  $form.on('submit', (event) => {
    event.preventDefault();

    $('#cookie-settings-saved').show();

    const formData = Object.fromEntries($form.serializeArray().map((element) => [element.name, element.value]));

    removeGACookies(
      formData,
      cookiesSaved,
    );
  });
});
