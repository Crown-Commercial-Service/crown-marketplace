module Cognito
  def self.pool_site
    Marketplace.cognito_user_pool_site
  end

  def self.client_id
    Marketplace.cognito_client_id
  end

  def self.logout_url(redirect)
    if pool_site.present?
      "#{pool_site}/logout?client_id=#{client_id}&redirect_uri=#{redirect}"
    else
      redirect
    end
  end
end
