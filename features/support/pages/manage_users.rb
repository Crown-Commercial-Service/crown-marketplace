module Pages
  class UserDetailRow < SitePrism::Section
    element :key, 'dt.govuk-summary-list__key'
    element :value, 'dd.govuk-summary-list__value'
    element :action, 'dd.govuk-summary-list__actions > a'
  end

  class UserAccountsRow < SitePrism::Section
    element :email, 'td:nth-child(1)'
    element :status, 'td:nth-child(2)'
    element :view, 'td:nth-child(3) > a'
  end

  class ViewUserRow < SitePrism::Section
    element :key, 'dt.govuk-summary-list__key'
    element :value, 'dd.govuk-summary-list__value'
    element :edit, 'dd.govuk-summary-list__actions > a'
  end

  class ManageUsers < SitePrism::Page
    section :user_details_summary, '#add-user-details-summary' do
      section :role, UserDetailRow, '#add-user-details-summary--roles'
      section :'service access', UserDetailRow, '#add-user-details-summary--service-access'
      section :email, UserDetailRow, '#add-user-details-summary--email'
      section :'telephone number', UserDetailRow, '#add-user-details-summary--telephone-number'
    end

    section :notification_banner, 'div.govuk-notification-banner' do
      element :heading, 'div.govuk-notification-banner__content > h3.govuk-notification-banner__heading'
      element :message, 'div.govuk-notification-banner__content > p.govuk-body'
    end

    section :find_a_user, '#email-form-group' do
      element :search, '#email'
      element :error, '#email-error'
    end

    section :find_a_user_table, '#users-table > table' do
      element :no_users, 'tbody > tr > td'
      sections :rows, UserAccountsRow, 'tbody > tr'
    end

    element :view_user_warning, '#main-content > div:nth-child(3) > div > div > strong'
    element :resend_temporary_password_button, '#resend-temporary-password-button'

    section :view_user_summary, 'dl.govuk-summary-list' do
      section :'Email address', ViewUserRow, '#view-user__email'
      section :'Email status', ViewUserRow, '#view-user__email-status'
      section :'Account status', ViewUserRow, '#view-user__account-status'
      section :'Confirmation status', ViewUserRow, '#view-user__confirmation-status'
      section :'Mobile telephone number', ViewUserRow, '#view-user__telephone-number'
      section :'MFA status', ViewUserRow, '#view-user__mfa-status'
      section :Roles, ViewUserRow, '#view-user__roles'
      section :'Service access', ViewUserRow, '#view-user__service-access'
    end

    element :email_status_verified, '#cognito_admin_user_email_verified_true'
    element :email_status_unverified, '#cognito_admin_user_email_verified_false'

    element :mfa_status_enabled, '#cognito_admin_user_mfa_enabled_true'
    element :mfa_status_disabled, '#cognito_admin_user_mfa_enabled_false'
    element :account_status_enabled, '#cognito_admin_user_account_status_true'
    element :account_status_disabled, '#cognito_admin_user_account_status_false'
  end
end
