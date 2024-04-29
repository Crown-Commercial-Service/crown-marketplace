module FacilitiesManagement::Admin::UploadsHelper
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
