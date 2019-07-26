module Cognito
  class SignUpUser < BaseService
    attr_reader :params, :roles
    attr_accessor :error, :user

    def initialize(params, roles)
      @params = params
      @roles = roles.compact
      @error = nil
      @user = nil
    end

    def call
      resp = create_cognito_user
      @cognito_uuid = resp['user_sub']
      add_user_to_groups
      create_user_object
    rescue Aws::CognitoIdentityProvider::Errors::ServiceError => e
      @error = e.message
    end

    def success?
      @error.nil? && @user.persisted?
    end

    private

    def create_cognito_user
      client.sign_up(
        client_id: ENV['COGNITO_CLIENT_ID'],
        username: params['email'],
        password: params['password'],
        user_attributes: [
          {
            name: 'email',
            value: params['email']
          }
        ]
      )
    end

    def add_user_to_groups
      @roles.each do |role|
        client.admin_add_user_to_group(
          user_pool_id: ENV['COGNITO_USER_POOL_ID'],
          username: @cognito_uuid,
          group_name: role.to_s
        )
      end
    end

    def create_user_object
      @user = User.create(user_params)
    end

    def user_params
      params.except(
        :password,
        :password_confirmation
      ).merge(
        cognito_uuid: @cognito_uuid,
        roles: roles
      )
    end
  end
end
