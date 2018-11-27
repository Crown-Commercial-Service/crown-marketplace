module Cognito
  def self.pool_site
    ENV.fetch('COGNITO_USER_POOL_SITE')
  end

  def self.client_id
    ENV.fetch('COGNITO_CLIENT_ID')
  end

  def self.logout_path(redirect)
    if pool_site.present?
      "#{pool_site}/logout?client_id=#{client_id}&logout_uri=#{redirect}"
    else
      redirect
    end
  end
end
