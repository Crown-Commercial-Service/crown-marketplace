RSpec.shared_context 'with cognito structs' do
  # Response structs
  let(:admin_create_user_resp_struct) { Struct.new(:user, keyword_init: true) }
  let(:admin_list_groups_for_user_resp_struct) { Struct.new(:groups, keyword_init: true) }
  let(:admin_get_user_resp_struct) { Struct.new(:user_attributes, :enabled, :user_status, :user_mfa_setting_list, keyword_init: true) }
  # rubocop:disable Naming/MethodName
  let(:forgot_password_resp_struct) { Struct.new(:USER_ID_FOR_SRP, keyword_init: true) }
  # rubocop:enable Naming/MethodName
  let(:initiate_auth_resp_struct) { Struct.new(:challenge_name, :session, :challenge_parameters, keyword_init: true) }
  let(:list_users_resp_struct) { Struct.new(:users, keyword_init: true) }
  let(:respond_to_auth_challenge_resp_struct) { Struct.new(:challenge_name, :session, keyword_init: true) }
  let(:resend_confirmation_code_resp_struct) { forgot_password_resp_struct }

  # Cogntio structs
  let(:cognito_group_struct) { Struct.new(:group_name, keyword_init: true) }
  let(:cognito_session_struct) { Struct.new(:session, keyword_init: true) }
  let(:cognito_user_attribute_struct) { Struct.new(:name, :value, keyword_init: true) }
  let(:cognito_user_struct) { Struct.new(:username, :enabled, :attributes, keyword_init: true) }
end
