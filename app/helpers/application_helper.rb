module ApplicationHelper
  def miles_to_metres(miles)
    DistanceConvertor.miles_to_metres(miles)
  end

  def metres_to_miles(metres)
    DistanceConvertor.metres_to_miles(metres)
  end

  def feedback_email_link
    if Marketplace.feedback_email_address.present?
      mail_to(Marketplace.feedback_email_address, 'feedback', class: 'govuk-link')
    else
      'feedback'
    end
  end

  def display_flash_error
    return unless flash[:error]

    content_tag :span, class: 'govuk-error-message' do
      flash[:error]
    end
  end
end
