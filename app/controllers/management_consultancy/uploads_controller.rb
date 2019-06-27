module ManagementConsultancy
  class UploadsController < FrameworkController
    before_action :authenticate_user!, except: :create
    before_action :authorize_user, except: :create

    # :nocov:
    if Rails.env.production?
      http_basic_authenticate_with(
        name: Marketplace.http_basic_auth_name,
        password: Marketplace.http_basic_auth_password
      )
    end
    # :nocov:

    def create
      suppliers = JSON.parse(request.body.read)

      Upload.upload!(suppliers)

      render json: {}, status: :created
    rescue ActiveRecord::RecordInvalid => e
      summary = {
        record: e.record,
        record_class: e.record.class.to_s,
        errors: e.record.errors
      }
      render json: summary, status: :unprocessable_entity
    end
  end
end
