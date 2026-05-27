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
end
