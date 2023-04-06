# rubocop:disable Metrics/ModuleLength
module Cognito
  module Admin
    module UserClientInterface
      class << self
        def find_user_from_cognito_uuid(cognito_uuid)
          client = new_client

          attributes = { cognito_uuid: }

          attributes.merge(find_user_in_cognito(client, cognito_uuid))
        end

        def create_user_and_return_errors(attributes, enable_mfa)
          client = new_client

          creat_user_resp = create_cognito_user(client, attributes, enable_mfa)
          cognito_uuid = creat_user_resp.user['username']
          add_user_mfa(client, cognito_uuid) if enable_mfa
          add_user_to_groups(client, cognito_uuid, attributes)

          nil
        rescue Aws::CognitoIdentityProvider::Errors::ServiceError => e
          e.message
        end

        def find_users_from_email(email)
          client = new_client

          list_users_resp = client.list_users(
            user_pool_id: ENV.fetch('COGNITO_USER_POOL_ID', nil),
            attributes_to_get: ['email'],
            filter: "email ^= \"#{email}\""
          )

          { users: get_users_attributes_from_response(list_users_resp) }
        rescue Aws::CognitoIdentityProvider::Errors::ServiceError => e
          { users: [], error: e.message }
        end

        def user_with_email_exists(email)
          client = new_client

          list_users_resp = client.list_users(
            user_pool_id: ENV.fetch('COGNITO_USER_POOL_ID', nil),
            attributes_to_get: ['email'],
            filter: "email = \"#{email}\""
          )

          { result: list_users_resp.users.any? }
        rescue Aws::CognitoIdentityProvider::Errors::ServiceError => e
          { error: e.message }
        end

        def update_user_and_return_errors(cognito_uuid, attributes, method)
          client = new_client

          case method
          when :email_verified
            update_email_verification(client, cognito_uuid, attributes)
          when :account_status
            update_enabled_status(client, cognito_uuid, attributes)
          when :telephone_number
            update_telephone_number(client, cognito_uuid, attributes)
          when :mfa_enabled
            update_mfa_status(client, cognito_uuid, attributes)
          when :roles, :service_access
            update_groups(client, cognito_uuid, attributes)
          end

          nil
        rescue Aws::CognitoIdentityProvider::Errors::ServiceError => e
          e.message
        end

        def resend_temporary_password(email)
          new_client.admin_create_user(
            user_pool_id: ENV.fetch('COGNITO_USER_POOL_ID', nil),
            username: email,
            message_action: 'RESEND',
            desired_delivery_mediums: ['EMAIL']
          )

          nil
        rescue Aws::CognitoIdentityProvider::Errors::ServiceError => e
          e.message
        end

        private

        def new_client
          Aws::CognitoIdentityProvider::Client.new(region: ENV.fetch('COGNITO_AWS_REGION', nil))
        end

        # Methods relating to creating a user
        def create_cognito_user(client, attributes, enable_mfa)
          client.admin_create_user(**determine_user_attributes(attributes, enable_mfa))
        end

        def determine_user_attributes(attributes, enable_mfa)
          user_attributes = {
            user_pool_id: ENV.fetch('COGNITO_USER_POOL_ID', nil),
            username: attributes[:email],
            user_attributes: [
              {
                name: 'email',
                value: attributes[:email]
              },
              {
                name: 'email_verified',
                value: 'true'
              }
            ],
            desired_delivery_mediums: ['EMAIL']
          }

          if enable_mfa
            user_attributes[:user_attributes] << {
              name: 'phone_number',
              value: formatted_phone_number(attributes[:telephone_number])
            }
          end

          user_attributes
        end

        def add_user_mfa(client, cognito_uuid)
          client.admin_set_user_mfa_preference(
            sms_mfa_settings: {
              enabled: true,
              preferred_mfa: true,
            },
            user_pool_id: ENV.fetch('COGNITO_USER_POOL_ID', nil),
            username: cognito_uuid,
          )
        end

        def add_user_to_groups(client, cognito_uuid, attributes)
          attributes[:groups].each do |group|
            client.admin_add_user_to_group(
              user_pool_id: ENV.fetch('COGNITO_USER_POOL_ID', nil),
              username: cognito_uuid,
              group_name: group.to_s
            )
          end
        end

        # Methods relating to finding users
        def get_users_attributes_from_response(resp)
          users = resp.users.map do |user|
            {
              cognito_uuid: user.username,
              email: get_attribute_value_from_user_attributes(user.attributes, 'email'),
              account_status: user.enabled
            }
          end

          users.sort_by { |user| user[:email] }
        end

        # Methods relating to finding a user
        def find_user_in_cognito(client, cognito_uuid)
          get_user_resp = client.admin_get_user(
            user_pool_id: ENV.fetch('COGNITO_USER_POOL_ID', nil),
            username: cognito_uuid
          )

          attributes = get_user_attributes_from_response(get_user_resp)

          get_groups_resp = client.admin_list_groups_for_user(
            user_pool_id: ENV.fetch('COGNITO_USER_POOL_ID', nil),
            username: cognito_uuid
          )

          attributes[:roles], attributes[:service_access] = Roles.get_roles_and_service_access_from_cognito_roles(get_groups_resp.groups.map(&:group_name))

          attributes
        rescue Aws::CognitoIdentityProvider::Errors::ServiceError => e
          { error: e.message }
        end

        def get_user_attributes_from_response(resp)
          attributes = {}

          attributes[:email] = get_attribute_value_from_user_attributes(resp.user_attributes, 'email')
          attributes[:email_verified] = get_attribute_value_from_user_attributes(resp.user_attributes, 'email_verified') == 'true'
          attributes[:telephone_number] = extract_telephone_number_from_response(get_attribute_value_from_user_attributes(resp.user_attributes, 'phone_number'))
          attributes[:account_status] = resp.enabled
          attributes[:confirmation_status] = resp.user_status
          attributes[:mfa_enabled] = resp.user_mfa_setting_list&.include?('SMS_MFA') || false

          attributes
        end

        def extract_telephone_number_from_response(telephone_number)
          telephone_number ||= ''

          if telephone_number.starts_with?('+44')
            "0#{telephone_number[3..]}"
          else
            telephone_number
          end
        end

        def update_email_verification(client, cognito_uuid, attributes)
          client.admin_update_user_attributes(
            user_pool_id: ENV.fetch('COGNITO_USER_POOL_ID', nil),
            username: cognito_uuid,
            user_attributes: [
              {
                name: 'email_verified',
                value: attributes[:email_verified].to_s
              }
            ]
          )
        end

        # Methods relating to updating the user
        def update_enabled_status(client, cognito_uuid, attributes)
          if attributes[:account_status]
            client.admin_enable_user(
              user_pool_id: ENV.fetch('COGNITO_USER_POOL_ID', nil),
              username: cognito_uuid
            )
          else
            client.admin_disable_user(
              user_pool_id: ENV.fetch('COGNITO_USER_POOL_ID', nil),
              username: cognito_uuid
            )
          end
        end

        def update_telephone_number(client, cognito_uuid, attributes)
          client.admin_update_user_attributes(
            user_pool_id: ENV.fetch('COGNITO_USER_POOL_ID', nil),
            username: cognito_uuid,
            user_attributes: [
              {
                name: 'phone_number',
                value: formatted_phone_number(attributes[:telephone_number])
              },
              {
                name: 'phone_number_verified',
                value: 'true'
              }
            ]
          )
        end

        def update_mfa_status(client, cognito_uuid, attributes)
          client.admin_set_user_mfa_preference(
            user_pool_id: ENV.fetch('COGNITO_USER_POOL_ID', nil),
            username: cognito_uuid,
            sms_mfa_settings: {
              enabled: attributes[:mfa_enabled],
              preferred_mfa: attributes[:mfa_enabled],
            }
          )
        end

        def update_groups(client, cognito_uuid, attributes)
          groups_to_add = attributes[:groups] - attributes[:origional_groups]
          groups_to_remove = attributes[:origional_groups] - attributes[:groups]

          groups_to_remove.each do |group|
            client.admin_remove_user_from_group(
              user_pool_id: ENV.fetch('COGNITO_USER_POOL_ID', nil),
              username: cognito_uuid,
              group_name: group.to_s
            )
          end

          groups_to_add.each do |group|
            client.admin_add_user_to_group(
              user_pool_id: ENV.fetch('COGNITO_USER_POOL_ID', nil),
              username: cognito_uuid,
              group_name: group.to_s
            )
          end
        end

        # Shared methods
        def formatted_phone_number(telephone_number)
          "+44#{telephone_number[1..]}"
        end

        def get_attribute_value_from_user_attributes(user_attributes, attribute)
          user_attributes.find { |user_attribute| user_attribute.name == attribute }&.value
        end
      end
    end
  end
end
# rubocop:enable Metrics/ModuleLength
