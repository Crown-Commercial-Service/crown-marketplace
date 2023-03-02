module FacilitiesManagement::Admin::UploadsHelper
  def upload_status_tag(status)
    case status
    when 'published'
      ['published on live']
    when 'failed'
      ['failed', :red]
    else
      ['in progress', :grey]
    end
  end

  def get_admin_upload_error_details(error, details)
    t("facilities_management.#{params[:framework].downcase}.admin.uploads.failed.error_details.#{error}_html", list: details_to_list(details))
  end

  def details_to_list(details)
    tag.ul class: 'govuk-list govuk-list--bullet' do
      details.each do |detail|
        concat(tag.li(detail))
      end
    end
  end
end
