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

  def get_upload_error_row(error)
    translation_scope = "#{service.module_parent.to_s.underscore}.#{params[:framework].downcase}.admin.uploads.failed"

    [
      {
        text: t("#{translation_scope}.error_name.#{error[:error]}"),
      },
      {
        text: error[:details] ? get_error_details(translation_scope, error[:error], error[:details]) : t("#{translation_scope}.error_details.#{error[:error]}"),
      },
    ]
  end

  def get_error_details(translation_scope, error, details)
    return t("#{translation_scope}.error_details.#{error}") unless details

    t("#{translation_scope}.error_details.#{error}_html", list: details.is_a?(Array) ? details_to_list(details) : details)
  end

  def details_to_list(details)
    tag.ul class: 'govuk-list govuk-list--bullet' do
      details.each do |detail|
        concat(tag.li(detail))
      end
    end
  end
end
