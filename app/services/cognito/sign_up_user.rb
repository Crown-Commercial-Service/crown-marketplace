module Cognito
  class SignUpUser < BaseService
    include ActiveModel::Validations

    validates :email, presence: true, format: { with: /\A[^A-Z]*\z/ }
    validates_format_of :email, with: /\A[^\s^@]+@[^\s^@]+\z/, message: :blank
    validates :password, presence: true, length: { within: 8..200 }
    validates_format_of :password, with: /(?=.*[A-Z])/, message: :invalid_no_capitals
    validates_format_of :password, with: /(?=.*\W)/, message: :invalid_no_symbol
    validates_format_of :password, with: /(?=.*\d)/, message: :invalid_no_number
    validates :password, confirmation: { case_sensitive: true }
    validates_presence_of :password_confirmation
    validate :domain_in_allow_list, unless: -> { email.blank? }

    attr_reader :email, :password, :password_confirmation, :roles
    attr_accessor :user, :not_on_safelist

    def initialize(email, password, password_confirmation, roles)
      @email = email
      @password = password
      @password_confirmation = password_confirmation
      @roles = roles.compact
      @user = nil
      @not_on_safelist = nil
      @skip_success = false
    end

    def call
      if valid?
        resp = create_cognito_user
        @cognito_uuid = resp['user_sub']
        add_user_to_groups
        create_user_object
      end
    rescue Aws::CognitoIdentityProvider::Errors::UsernameExistsException
      # We do nothing as we don't want people to be able enumerate users
      @skip_success = true
    rescue Aws::CognitoIdentityProvider::Errors::ServiceError => e
      errors.add(:base, e.message)
    end

    def success?
      return true if @skip_success

      errors.empty? && @user.try(:persisted?)
    end

    private

    def create_cognito_user
      client.sign_up(
        client_id: ENV['COGNITO_CLIENT_ID'],
        username: email,
        password: password,
        user_attributes: [
          {
            name: 'email',
            value: email
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
      {
        email: email,
        cognito_uuid: @cognito_uuid,
        roles: roles
      }
    end

    def domain_in_allow_list
      return if AllowedEmailDomain.new(email_domain: domain_name).domain_in_allow_list?

      errors.add(:email, :not_on_safelist)
      @not_on_safelist = true
    end

    def domain_name
      email.split('@').last
    end
  end
end
