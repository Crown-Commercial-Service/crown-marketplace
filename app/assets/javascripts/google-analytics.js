document.addEventListener('DOMContentLoaded', function() {
  var cssClassToClickPath = {
    'ga-crown-logo': 'crown_logo',
    'ga-feedback-mailto': 'feedback',
    'ga-support-mailto': 'support',
    'ga-auth-cognito': 'cognito_login',
    'ga-auth-dfe': 'dfe_login',
    'ga-print-link': 'print',
    'ga-download-shortlist': 'shortlist_download',
    'ga-download-calculator': 'calculator_download'
  };

  if (window.gaTrackingId) {
    for (var cssClass in cssClassToClickPath) {
      var elements = document.getElementsByClassName(cssClass);
      for (var idx=0; idx < elements.length; idx++) {
        var element = elements[idx];
        var onClick = function(cssClass) {
          return function() {
            var page = cssClassToClickPath[cssClass];
            var params = {
              'anonymize_ip': true,
              'page_title': page,
              'page_path': '/external/'+page
            };
            gtag('config', window.gaTrackingId, params);
          }
        }(cssClass);
        element.addEventListener('click', onClick, false);
      }
    }
  }
});
