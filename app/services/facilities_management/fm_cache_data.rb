require 'json'
require 'base64'
class FMCacheData

  def create_cache_table
    query = 'CREATE TABLE if not exists fm_cache (user_id varchar NOT NULL,"key" varchar NOT NULL,value varchar NULL);'
    ActiveRecord::Base.connection_pool.with_connection { |con| con.exec_query(query) }
    query = 'CREATE INDEX if not exists fm_cache_user_id_idx ON fm_cache USING btree (user_id, key);'
    ActiveRecord::Base.connection_pool.with_connection { |con| con.exec_query(query) }
  rescue StandardError => e
    Rails.logger.warn "Couldn't create FM cache table: #{e}"
  end

  def cache_data(email_address, key, value)
    Rails.logger.info '==> FMCacheData.cache_data()'
    create_cache_table
    clear(email_address, key)
    query = "INSERT INTO fm_cache (user_id, key, value) VALUES('" + Base64.encode64(email_address) + "', '" + key + "', '" + value.to_s + "');"
    ActiveRecord::Base.connection_pool.with_connection { |con| con.exec_query(query) }
  rescue StandardError => e
    Rails.logger.warn "Couldn't cache data: #{e}"
  end

  def retrieve_cache_data(email_address, key)
    Rails.logger.info '==> FMCacheData.retrieve_cache_data()'
    create_cache_table
    query = "SELECT value FROM fm_cache where user_id = '" + Base64.encode64(email_address) + "' and key = '" + key + "';"
    ActiveRecord::Base.connection_pool.with_connection { |con| con.exec_query(query) }
  rescue StandardError => e
    Rails.logger.warn "Couldn't retrieve cache data: #{e}"
  end

  def clear(email_address, key)
    Rails.logger.info '==> FMCacheData.clear()'
    create_cache_table
    query = "DELETE FROM public.fm_cache WHERE user_id = '" + Base64.encode64(email_address) + "' and key = '" + key + "';"
    ActiveRecord::Base.connection_pool.with_connection { |con| con.exec_query(query) }
  rescue StandardError => e
    Rails.logger.warn "Couldn't clear cache data: #{e}"
  end

  def clear_all(email_address)
    Rails.logger.info '==> FMCacheData.clear_all()'
    create_cache_table
    query = "DELETE FROM public.fm_cache WHERE user_id = '" + Base64.encode64(email_address) + "'"
    ActiveRecord::Base.connection_pool.with_connection { |con| con.exec_query(query) }
  rescue StandardError => e
    Rails.logger.warn "Couldn't clear all cache data: #{e}"
  end
end
