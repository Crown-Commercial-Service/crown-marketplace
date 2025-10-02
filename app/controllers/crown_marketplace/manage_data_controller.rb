class CrownMarketplace::ManageDataController < CrownMarketplace::FrameworkController
  before_action :authorize_user
  before_action :set_data_loader, only: %i[new create]

  helper_method :available_tasks

  def index; end

  def new; end

  def create
    if @data_loader.valid?
      if @data_loader.application == 'fm'
        DataLoaderWorker
      else
        LegacyDataLoaderWorker
      end.perform_async(@data_loader.task_name)

      flash[:task_details] = { application: @data_loader.application, task_name: @data_loader.task_name }

      redirect_to crown_marketplace_manage_data_path
    else
      render :new
    end
  end

  private

  def available_tasks
    DataLoader::AVAILABL_TASKS
  end

  def set_data_loader
    @data_loader = DataLoader.new(**data_loader_attributes)
  end

  def data_loader_attributes
    params[:data_loader].present? ? params.expect(data_loader: %i[application task_name]) : {}
  end

  protected

  def authorize_user
    authorize! :manage, Framework
  end
end
