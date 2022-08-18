module SharedPagesConcern
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!, :authorize_user, except: %i[not_permitted accessibility_statement cookie_policy cookie_settings update_cookie_settings]
  end

  def not_permitted
    render 'home/not_permitted', layout: 'error'
  end

  def accessibility_statement
    render 'home/accessibility_statement'
  end

  def cookie_policy
    render 'home/cookie_policy'
  end

  def cookie_settings
    render 'home/cookie_settings'
  end

  def update_cookie_settings
    if params[:ga_cookie_usage] == 'true'
      cookies[:crown_marketplace_google_analytics_enabled] = {
        value: 'true',
        expires: 1.year.from_now
      }
    else
      cookies.delete(:crown_marketplace_google_analytics_enabled)

      cookies.each do |cookie_name, _|
        cookies.delete(cookie_name, path: '/', domain: '.crowncommercial.gov.uk') if COOKIE_PREFIXES.any? { |cookie_prefix| cookie_name.start_with? cookie_prefix }
      end
    end

    params[:cookies_updated] = true

    render 'home/cookie_settings'
  end

  COOKIE_PREFIXES = %w[_ga _gi _cls].freeze
end
