module Admin::FrameworksController
  extend ActiveSupport::Concern

  include Admin::SupplierPathsConcern

  included do
    before_action :authenticate_user!, :authorize_user
    before_action :set_framework

    helper_method :service
  end

  def show
    render template: 'shared/admin/frameworks/show'
  end

  def edit
    render template: 'shared/admin/frameworks/edit'
  end

  def update
    if @framework.update(framework_params)
      redirect_to framework_show_path
    else
      render template: 'shared/admin/frameworks/edit'
    end
  end

  private

  def authorize_user
    authorize! :manage, Framework
  end

  def service
    @service ||= self.class.module_parent.module_parent
  end

  def set_framework
    @framework = FrameworkUpdate.find(params.expect(:framework))
  end

  def framework_params
    params
      .expect(
        framework_update: %i[
          live_at_dd
          live_at_mm
          live_at_yyyy
          expires_at_dd
          expires_at_mm
          expires_at_yyyy
        ],
      )
  end
end
