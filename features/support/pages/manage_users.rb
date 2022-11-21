module Pages
  class UserDetailRow < SitePrism::Section
    element :key, 'dt.govuk-summary-list__key'
    element :value, 'dd.govuk-summary-list__value'
    element :action, 'dd.govuk-summary-list__actions > a'
  end

  class ManageUsers < SitePrism::Page
    section :user_details_summary, '#add-user-details-summary' do
      section :role, UserDetailRow, '#add-user-details-summary--roles'
      section :'service access', UserDetailRow, '#add-user-details-summary--service-access'
      section :email, UserDetailRow, '#add-user-details-summary--email'
      section :'telephone number', UserDetailRow, '#add-user-details-summary--telephone-number'
    end

    section :notification_banner, 'div.govuk-notification-banner' do
      element :heading, 'p.govuk-notification-banner__heading'
      element :content, 'div.govuk-notification-banner__content'
    end
  end
end
