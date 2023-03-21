COGNITO_RESPONSE_STRUCTS = {
  admin_create_user: Struct.new(:user, keyword_init: true),
  admin_list_groups_for_user: Struct.new(:groups, keyword_init: true),
  admin_get_user: Struct.new(:user_attributes, :enabled, :user_status, :user_mfa_setting_list, keyword_init: true),
  initiate_auth: Struct.new(:challenge_name, :session, :challenge_parameters, keyword_init: true),
  list_users: Struct.new(:users, keyword_init: true),
  respond_to_auth_challenge: Struct.new(:challenge_name, :session, keyword_init: true)
}.freeze

COGNITO_OBJECT_STRUCTS = {
  cognito_group: Struct.new(:group_name, keyword_init: true),
  cognito_user_attribute: Struct.new(:name, :value, keyword_init: true),
  cognito_user: Struct.new(:username, :enabled, :attributes, keyword_init: true)
}.freeze
