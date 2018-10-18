module ApplicationHelper
  def miles_to_metres(miles)
    DistanceConvertor.miles_to_metres(miles)
  end

  def metres_to_miles(metres)
    DistanceConvertor.metres_to_miles(metres)
  end

  def feedback_mail_to(name = nil, html_options = {}, &block)
    mail_to(Marketplace.feedback_email_address, name, html_options, &block)
  end
end
