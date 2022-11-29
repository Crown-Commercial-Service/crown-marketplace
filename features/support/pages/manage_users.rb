module Pages
  class UserDetailRow < SitePrism::Section
    element :key, 'dt.govuk-summary-list__key'
    element :value, 'dd.govuk-summary-list__value'
    element :action, 'dd.govuk-summary-list__actions > a'
  end

  class UserAccountsRow < SitePrism::Section
    element :email, 'td:nth-child(1)'
    element :status, 'td:nth-child(2)'
    element :view, 'td:nth-child(3)'
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

    section :find_a_user, '#email-form-group' do
      element :search, '#email'
      element :error, '#email-error'
    end

    section :find_a_user_table, '#users-table > table' do
      element :no_users, 'tbody > tr > td'
      sections :rows, UserAccountsRow, 'tbody > tr'
    end
  end
end
