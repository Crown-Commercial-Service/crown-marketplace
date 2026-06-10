module Admin::DashboardActions
  extend ActiveSupport::Concern

  include Admin::SupplierPathsConcern

  included do
    before_action :authenticate_user!, :authorize_user, only: %i[index]

    helper_method :service, :framework_has_analytics?
  end

  def index
    render template: 'shared/admin/dashboard/index'
  end

  private

  def authorize_user
    authorize! :manage, service.module_parent::Admin
  end

  def service
    @service ||= self.class.module_parent.module_parent
  end

  def framework_has_analytics?
    true
  end
end
