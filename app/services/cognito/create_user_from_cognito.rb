module Cognito
  class CreateUserFromCognito < BaseService
    attr_reader :username
    attr_accessor :error, :user

    def initialize(username)
      @username = username.try(:downcase)
      @error = nil
    end

    def call
      @cognito_user = client.admin_get_user(user_pool_id: ENV.fetch('COGNITO_USER_POOL_ID', nil), username: username)
      @cognito_uuid = cognito_attribute('sub')
      @cognito_user_groups = client.admin_list_groups_for_user(user_pool_id: ENV.fetch('COGNITO_USER_POOL_ID', nil), username: @cognito_uuid)
      create_or_update_user
    rescue Aws::CognitoIdentityProvider::Errors::ServiceError => e
      @error = e.message
    end

    def success?
      @error.nil?
    end

    private

    def create_or_update_user
      if (@user = User.find_by(email: cognito_attribute('email')))
        @user.update(
          cognito_uuid: @cognito_uuid,
          first_name: cognito_attribute('name'),
          last_name: cognito_attribute('family_name'),
          phone_number: cognito_attribute('phone_number'),
          roles: roles
        )
      else
        @user = User.create(
          email: cognito_attribute('email'),
          cognito_uuid: @cognito_uuid,
          first_name: cognito_attribute('name'),
          last_name: cognito_attribute('family_name'),
          phone_number: cognito_attribute('phone_number'),
          roles: roles
        )
      end
      update_supplier_details if @user.has_roles?('supplier', 'fm_access')
    end

    def cognito_attribute(attr)
      @cognito_user.user_attributes.select { |u| u.name == attr }.try(:first).try(:value)
    end

    def roles
      @cognito_user_groups.groups.map { |g| g.group_name.to_sym }
    end

    def update_supplier_details
      @user.supplier_detail = FacilitiesManagement::RM3830::SupplierDetail.find_by(contact_email: @user.email)
      @user.save
    end
  end
end
