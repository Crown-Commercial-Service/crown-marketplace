module Admin::UploadActions
  extend ActiveSupport::Concern

  include Admin::SupplierPathsConcern

  included do
    skip_before_action :verify_authenticity_token, only: :create
    before_action :authenticate_user!, :authorize_user
    before_action :set_latest_upload, :set_uploads, only: %i[index]
    before_action :set_upload, only: %i[show progress]

    helper_method :service, :service_key
  end

  def index
    render template: 'shared/admin/uploads/index'
  end

  def show
    render template: 'shared/admin/uploads/show'
  end

  def new
    @upload = service::Admin::Upload.new

    render template: 'shared/admin/uploads/new'
  end

  def create
    @upload = service::Admin::Upload.new(user: current_user, framework_id: self.class.name.split('::')[1], **upload_params)

    if @upload.save(context: :upload)
      @upload.start_upload!
      redirect_to @upload
    else
      render template: 'shared/admin/uploads/new'
    end
  end

  def progress
    render json: { import_status: @upload.aasm_state }
  end

  private

  def service_key
    raise NotImplementedError
  end

  def set_latest_upload
    @latest_upload = service::Admin::Upload.latest_upload
  end

  def set_uploads
    @uploads = service::Admin::Upload.all.page params[:page]
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
