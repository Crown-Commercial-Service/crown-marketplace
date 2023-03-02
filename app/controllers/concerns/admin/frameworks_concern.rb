module Admin::FrameworksConcern
  extend ActiveSupport::Concern

  included do
    before_action :raise_if_unrecognised_framework, except: %i[index edit update]
    before_action :set_framework, only: %i[edit update]
  end

  def index
    @frameworks = Framework.public_send(service_scope)
  end

  def edit; end

  def update
    if @framework.update(framework_params)
      redirect_to framework_index_path
    else
      render :edit
    end
  end

  private

  def set_framework
    @framework = Framework.find(params[:id])
  end

  def framework_params
    params.require(:framework)
          .permit(
            :live_at_dd,
            :live_at_mm,
            :live_at_yyyy,
            :expires_at_dd,
            :expires_at_mm,
            :expires_at_yyyy,
          )
  end
end
