module GovUKHelper::NotificationBanner
  def govuk_notification_banner(type, heading, &block)
    tag.div(class: "govuk-notification-banner #{BANNER_TYPE[type][:class]}", role: 'region', aria: { labelledby: 'govuk-notification-banner-title' }, data: { module: 'govuk-notification-banner' }) do
      capture do
        concat(tag.div(class: 'govuk-notification-banner__header') do
          tag.h2(BANNER_TYPE[type][:text], class: 'govuk-notification-banner__title', id: 'govuk-notification-banner-title')
        end)
        concat(tag.div(class: 'govuk-notification-banner__content') do
          capture do
            concat(tag.p(heading, class: 'govuk-notification-banner__heading'))
            concat(tag.p(class: 'govuk-body', &block)) if block_given?
          end
        end)
      end
    end
  end

  BANNER_TYPE = {
    success: { class: 'govuk-notification-banner--success', text: 'Success' },
    error: { class: 'govuk-notification-banner--error', text: 'Error' },
    neutral: { text: 'Important' }
  }.freeze
end
