module CookieSettingsConcern
  extend ActiveSupport::Concern

  def update_cookie_settings
    update_cookie_preferences

    cookies[Marketplace.cookie_settings_name] = {
      value: cookie_preferences_settings.to_json,
      expires: 1.year.from_now
    }

    params[:cookies_updated] = true

    respond_to do |format|
      format.html { render 'home/cookie_settings' }
      format.json { render json: { cookies_updated: true } }
    end
  end

  private

  def cookie_preferences_settings
    @cookie_preferences_settings ||= begin
      current_cookie_preferences = JSON.parse(cookies[Marketplace.cookie_settings_name] || '{}')

      current_cookie_preferences.empty? ? Marketplace.default_cookie_options : current_cookie_preferences
    end
  end

  def update_cookie_preferences
    cookie_prefixes = []

    COOKIE_UPDATE_OPTIONS.each do |cookie_update_option|
      if params[cookie_update_option[:param_name]] == 'true'
        cookie_preferences_settings[cookie_update_option[:cookie_name]] = true
      else
        cookie_preferences_settings[cookie_update_option[:cookie_name]] = false

        cookie_prefixes += cookie_update_option[:cookie_prefixes]
      end
    end

    delete_unwanted_cookie(cookie_prefixes)

    cookie_preferences_settings['settings_viewed'] = true
  end

  def delete_unwanted_cookie(cookie_prefixes)
    return unless cookie_prefixes.any?

    cookies.each do |cookie_name, _|
      cookies.delete(cookie_name, path: '/', domain: '.crowncommercial.gov.uk') if cookie_prefixes.any? { |cookie_prefix| cookie_name.start_with? cookie_prefix }
    end
  end

  COOKIE_UPDATE_OPTIONS = [
    {
      param_name: :ga_cookie_usage,
      cookie_name: 'google_analytics_enabled',
      cookie_prefixes: %w[_ga _gi]
    },
    {
      param_name: :glassbox_cookie_usage,
      cookie_name: 'glassbox_enabled',
      cookie_prefixes: %w[_cls]
    }
  ].freeze
end
