class CrownMarketplace::ManageUsersController < CrownMarketplace::FrameworkController
  before_action :authorize_user, :set_current_user_access
  before_action :redirect_if_unrecognised_add_user_section, :continue_if_user_support, only: %i[add_user create_add_user]
  before_action :continue_if_role_does_not_require_service_access, only: :add_user
  before_action :set_new_user, only: %i[add_user new]

  helper_method :section, :available_roles, :role_requires_service_access?

  def index
    @search = if find_user_params.empty?
                { users: [] }
              else
                Cognito::Admin::User.search(find_user_params[:email])
              end

    respond_to do |format|
      format.js
      format.html { render :index }
    end
  end

  def add_user; end

  def create_add_user
    @user = Cognito::Admin::User.new(@current_user_access, add_user_params)

    if @user.valid?(section)
      next_section = ADD_USER_SECTIONS[ADD_USER_SECTIONS.index(section) + 1]

      if next_section
        redirect_to add_user_crown_marketplace_manage_users_path(section: next_section.to_s.dasherize, **add_user_params.to_h)
      else
        redirect_to new_crown_marketplace_manage_user_path(**add_user_params.to_h)
      end
    else
      render :add_user
    end
  end

  def new; end

  def create
    @user = Cognito::Admin::User.new(@current_user_access, create_user_params)

    if @user.create
      flash[:account_added] = @user.email

      redirect_to crown_marketplace_path
    else
      render :new
    end
  end

  private

  def section
    @section ||= params[:section]&.underscore&.to_sym
  end

  def available_roles
    @available_roles ||= @user&.cognito_roles&.available_roles || Cognito::Admin::Roles.find_available_roles(@current_user_access)
  end

  def redirect_if_unrecognised_add_user_section
    redirect_to crown_marketplace_path unless ADD_USER_SECTIONS.include?(section)
  end

  def continue_if_user_support
    redirect_to add_user_crown_marketplace_manage_users_path(section: 'select-service-access', roles: ['buyer']) if section == :select_role && @current_user_access == :user_support
  end

  def continue_if_role_does_not_require_service_access
    return unless section == :select_service_access && !role_requires_service_access?(params[:roles])

    redirect_to add_user_crown_marketplace_manage_users_path(section: 'enter-user-details', **filter_user_params)
  end

  def add_user_params
    if params[:cognito_admin_user]
      params.require(:cognito_admin_user).permit(ADD_USER_PERMITTED_PARAMS)
    else
      {}
    end
  end

  def create_user_params
    if params[:cognito_admin_user]
      params.require(:cognito_admin_user).permit(CREATE_PERMITTED_PARAMS)
    else
      {}
    end
  end

  def find_user_params
    @find_user_params ||= params.permit(:email)
  end

  def role_requires_service_access?(roles)
    [['buyer'], ['ccs_employee']].include?(roles)
  end

  def authorize_user
    authorize! :read, AllowedEmailDomain
  end

  def set_current_user_access
    @current_user_access = Cognito::Admin::Roles.current_user_access(current_ability)
  end

  def set_new_user
    @user = Cognito::Admin::User.new(@current_user_access, filter_user_params)
  end

  def filter_user_params
    {
      roles: params[:roles],
      service_access: params[:service_access],
      email: params[:email],
      telephone_number: params[:telephone_number]
    }.select { |_, value| value.present? }
  end

  ADD_USER_SECTIONS = %i[select_role select_service_access enter_user_details].freeze
  ADD_USER_PERMITTED_PARAMS = [
    :email,
    :telephone_number,
    { roles: [] },
    { service_access: [] }
  ].freeze
  CREATE_PERMITTED_PARAMS = [
    :email,
    :telephone_number,
    { roles: [] },
    { service_access: [] }
  ].freeze
end
