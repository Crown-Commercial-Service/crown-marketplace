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
      section :role, UserDetailRow, :xpath, '//dt[@class="govuk-summary-list__key"][text()="Role"]/..'
      section :'service access', UserDetailRow, :xpath, '//dt[@class="govuk-summary-list__key"][text()="Service access"]/..'
      section :email, UserDetailRow, :xpath, '//dt[@class="govuk-summary-list__key"][text()="Email address"]/..'
      section :'telephone number', UserDetailRow, :xpath, '//dt[@class="govuk-summary-list__key"][text()="Mobile telephone number"]/..'
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

    element :view_user_warning, '#main-content > div:nth-child(1) > div > div > strong'
    element :resend_temporary_password_button, '#resend-temporary-password-button'

    section :view_user_summary, 'dl.govuk-summary-list' do
      section :'Email address', ViewUserRow, :xpath, '//dt[@class="govuk-summary-list__key"][text()="Email address"]/..'
      section :'Email status', ViewUserRow, :xpath, '//dt[@class="govuk-summary-list__key"][text()="Email status"]/..'
      section :'Account status', ViewUserRow, :xpath, '//dt[@class="govuk-summary-list__key"][text()="Account status"]/..'
      section :'Confirmation status', ViewUserRow, :xpath, '//dt[@class="govuk-summary-list__key"][text()="Confirmation status"]/..'
      section :'Mobile telephone number', ViewUserRow, :xpath, '//dt[@class="govuk-summary-list__key"][text()="Mobile telephone number"]/..'
      section :'MFA status', ViewUserRow, :xpath, '//dt[@class="govuk-summary-list__key"][text()="MFA status"]/..'
      section :Roles, ViewUserRow, :xpath, '//dt[@class="govuk-summary-list__key"][text()="Roles"]/..'
      section :'Service access', ViewUserRow, :xpath, '//dt[@class="govuk-summary-list__key"][text()="Service access"]/..'
    end

    element :email_status_verified, '#cognito_admin_user_email_verified_true'
    element :email_status_unverified, '#cognito_admin_user_email_verified_false'

    element :mfa_status_enabled, '#cognito_admin_user_mfa_enabled_true'
    element :mfa_status_disabled, '#cognito_admin_user_mfa_enabled_false'
    element :account_status_enabled, '#cognito_admin_user_account_status_true'
    element :account_status_disabled, '#cognito_admin_user_account_status_false'
  end
end
