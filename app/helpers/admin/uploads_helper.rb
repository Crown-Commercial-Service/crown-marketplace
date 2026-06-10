module Admin::UploadsHelper
  def upload_status_tag(status)
    case status
    when 'published'
      ['Published on live']
    when 'failed'
      ['Failed', :red]
    else
      ['In progress', :grey]
    end
  end

  def get_error_details(error, details)
    service_name = service.module_parent.to_s.underscore
    framework = params[:framework].downcase

    return t("#{service_name}.#{framework}.admin.uploads.failed.error_details.#{error}") unless details

    t("#{service_name}.#{framework}.admin.uploads.failed.error_details.#{error}_html", list: details.is_a?(Array) ? details_to_list(details) : details)
  end

  def details_to_list(details)
    tag.ul class: 'govuk-list govuk-list--bullet' do
      details.each do |detail|
        concat(tag.li(detail))
      end
    end
  end
end
