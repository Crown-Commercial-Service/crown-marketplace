require 'json'
require 'facilities_management/fm_cache_data'
class FacilitiesManagement::CacheController < ApplicationController
  require_permission :facilities_management, only: %i[set retrieve clear_all clear_by_key].freeze

  def set
    raw_post = request.raw_post
    post_json = JSON.parse(raw_post)
    key = post_json['key']
    value = post_json['value']
    current_login_email = current_user.email.to_s
    cache = FMCacheData.new
    cache.cache_data(current_login_email, key, value)
    j = { 'status': 200 }
    render json: j, status: 200
  end

  def retrieve
    raw_post = request.raw_post
    post_json = JSON.parse(raw_post)
    key = post_json['key']
    current_login_email = current_user.email.to_s
    cache = FMCacheData.new
    result = cache.retrieve_cache_data(current_login_email, key)
    j = { 'status': 200, result: result }
    render json: j, status: 200
  end

  def clear_by_key
    raw_post = request.raw_post
    post_json = JSON.parse(raw_post)
    key = post_json['key']
    current_login_email = current_user.email.to_s
    cache = FMCacheData.new
    cache.clear(current_login_email, key)
    j = { 'status': 200 }
    render json: j, status: 200
  end

  def clear_all
    current_login_email = current_user.email.to_s
    cache = FMCacheData.new
    cache.clear_all(current_login_email)
    j = { 'status': 200 }
    render json: j, status: 200
  end
end
