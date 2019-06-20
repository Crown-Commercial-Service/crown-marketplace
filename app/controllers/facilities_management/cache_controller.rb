require 'json'
require 'facilities_management/fm_cache_data'
class FacilitiesManagement::CacheController < ApplicationController
  require_permission :facilities_management, only: %i[set get clear].freeze

  def set
    raw_post = request.raw_post
    post_json = JSON.parse(raw_post)
    key = post_json['key']
    value = post_json['value']
    current_login_email = current_login.email.to_s
    cache = FMCacheData.new
    cache.cache_data(current_login_email, key, value)
    j = { 'status': 200 }
    render json: j, status: 200
  end
end
