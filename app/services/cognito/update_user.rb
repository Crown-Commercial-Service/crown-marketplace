module Cognito
  class UpdateUser < BaseService
    attr_accessor :error, :user

    def initialize(user)
      @user = user
      @error = nil
    end

    def call
      @cognito_user_groups = client.admin_list_groups_for_user(user_pool_id: ENV.fetch('COGNITO_USER_POOL_ID', nil), username: username)
      update_user
    rescue Aws::CognitoIdentityProvider::Errors::ServiceError => e
      @error = e.message
    end

    private

    def update_user
      @user.roles = roles
      @user.save
    end

    def username
      user.cognito_uuid || user.email
    end

    def roles
      @cognito_user_groups.groups.map { |g| g.group_name.to_sym }
    end
  end
end
