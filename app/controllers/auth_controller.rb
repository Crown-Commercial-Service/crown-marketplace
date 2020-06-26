class AuthController < ApplicationController
  before_action :authenticate_user!, except: :callback
  def callback
    login = Login.from_omniauth(request.env['omniauth.auth'])
    raise CanCan::AccessDenied.new('Not authorized!', :read, SupplyTeachers) unless login.permit?(:supply_teachers)

    user = find_or_create(login)
    sign_in user
    redirect_to session[:requested_path] || supply_teachers_path
  end

  protected

  def find_or_create(login)
    user = User.find_or_initialize_by(email: login.email)
    user.new_record?
    user.roles = %i[buyer st_access]
    user.save
    user
  end
end
