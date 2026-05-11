module Admin::UploadsController
  extend ActiveSupport::Concern

  included do
    skip_before_action :verify_authenticity_token, only: :create
    before_action :authenticate_user!, :authorize_user
    before_action :set_upload, only: %i[show progress]

    helper_method :service, :new_path, :index_path
  end

  def index
    @latest_upload = service::Admin::Upload.latest_upload
    @uploads = service::Admin::Upload.all.page params[:page]
  end

  def show; end

  def new
    @upload = service::Admin::Upload.new
  end

  def create
    @upload = service::Admin::Upload.new(user: current_user, framework_id: self.class.name.split('::')[1], **upload_params)

    if @upload.save(context: :upload)
      @upload.start_upload!
      redirect_to @upload
    else
      render :new
    end
  end

  def progress
    render json: { import_status: @upload.aasm_state }
  end

  private

  def new_path
    "#{service_path_base}/uploads/new"
  end

  def index_path
    "#{service_path_base}/uploads"
  end

  def set_upload
    @upload = service::Admin::Upload.find(params[:id] || params[:upload_id])
  end

  def authorize_user
    authorize! :manage, service.module_parent::Admin
  end

  def service
    @service ||= self.class.module_parent.module_parent
  end
end
