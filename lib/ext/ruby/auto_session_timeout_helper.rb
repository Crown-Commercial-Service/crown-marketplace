module AutoSessionTimeoutHelper
  def auto_session_timeout_js(options = {})
    frequency = options[:frequency] || 60
    attributes = options[:attributes] || {}
    code = <<~JS
      function PeriodicalQuery() {
        var request = new XMLHttpRequest();
        request.onload = function (event) {
          var status = event.target.status;
          var response = event.target.response;
          if (status === 200 && (response === false || response === 'false' || response === null)) {
            window.location.href = timout_url;
          }
          };
          request.open('GET', '#{active_path}', true);
          request.responseType = 'json';
          request.send();
          setTimeout(PeriodicalQuery, (#{frequency} * 1000));
        }

      var current_url = encodeURIComponent(window.location.pathname +  window.location.search)
      var timout_url = '#{timeout_path}' + '?url=' + current_url;

      setTimeout(PeriodicalQuery, (#{frequency} * 1000));
    JS
    javascript_tag(code, attributes)
  end
end

ActionView::Base.include AutoSessionTimeoutHelper
