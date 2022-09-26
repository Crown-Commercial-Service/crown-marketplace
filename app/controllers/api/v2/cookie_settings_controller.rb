module Api
  module V2
    class CookieSettingsController < ApplicationController
      include CookieSettingsConcern

      before_action :authenticate_user!, :validate_service, except: :update_cookie_settings
    end
  end
end
