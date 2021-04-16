def create_user_with_details
  create_user(:with_detail)
end

def create_user_without_details
  create_user(:without_detail)
end

def create_user(option)
  @user = create(:user, option, confirmed_at: Time.zone.now, roles: %i[buyer fm_access])
  allow_any_instance_of(Cognito::UpdateUser).to receive(:call).and_return(true)
  allow_any_instance_of(Cognito::UpdateUser).to receive(:call).with(anything).and_return(true)
end
