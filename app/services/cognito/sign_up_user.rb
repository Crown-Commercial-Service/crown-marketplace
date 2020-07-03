module Cognito
  class SignUpUser < BaseService
    include ActiveModel::Validations
    validates_presence_of :email, :password, :password_confirmation

    validates :password,
              presence: true,
              confirmation: { case_sensitive: true },
              length: { within: 8..200 }

    validates_format_of :password, with: /(?=.*[A-Z])/, message: :invalid_no_capitals
    validates_format_of :password, with: /(?=.*\W)/, message: :invalid_no_symbol
    validate :domain_in_whitelist

    attr_reader :email, :password, :password_confirmation, :roles
    attr_accessor :user, :not_on_whitelist

    def initialize(email, password, password_confirmation, roles)
      @email = email
      @password = password
      @password_confirmation = password_confirmation
      @roles = roles.compact
      @user = nil
      @not_on_whitelist = nil
    end

    def call
      if valid?
        resp = create_cognito_user
        @cognito_uuid = resp['user_sub']
        add_user_to_groups
        create_user_object
      end
    rescue Aws::CognitoIdentityProvider::Errors::ServiceError => e
      errors.add(:base, e.message)
    end

    def success?
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

    def domain_in_whitelist
      return if whitelist.include? domain_name

      errors.add(:email, :not_on_whitelist)
      @not_on_whitelist = true
    end

    def whitelist
      ENV['RAILS_MASTER_KEY_2'] = ENV['SECRET_KEY_BASE'][0..31] if ENV['SECRET_KEY_BASE']
      creds = ActiveSupport::EncryptedConfiguration.new(
        config_path: Rails.root.join('config', 'credentials.yml.enc'),
        key_path: 'config/master.key',
        env_key: 'RAILS_MASTER_KEY_2',
        raise_if_missing_key: false
      )

      access_key = creds.aws_postcodes[:access_key_id]
      secret_key = creds.aws_postcodes[:secret_access_key]
      bucket     = ENV['BUYER_EMAIL_NICE_LIST_BUCKET']
      region     = creds.aws_postcodes[:region]

      Aws.config[:credentials] = Aws::Credentials.new(access_key, secret_key)
      object = Aws::S3::Resource.new(region: region)
      object.bucket(bucket).object(ENV['BUYER_EMAIL_NICE_LIST_KEY']).get.body.string.split("\n")
    end

    def domain_name
      email.split('@').last
    end
  end
end
