module Pages
  class EmailDomainRowSection < SitePrism::Section
    element :email_domain, 'td:nth-of-type(1)'
    element :remove_link, 'td:nth-of-type(2) > a'
  end

  class AllowList < SitePrism::Page
    section :email_domains_table, '#allow-list-table > table' do
      sections :rows, EmailDomainRowSection, 'tbody > tr'
    end

    section :email_domain_search, '#allow-list-search-container > div > form' do
      element :input, '#allowed_email_domain_email_domain'
      element :button, 'input.govuk-button.govuk-button--secondary'
    end

    section :add_email_domain_form, '#email_domain-form-group' do
      element :email_domain, '#allowed_email_domain_email_domain'
    end

    section :notification_banner, '#main-content > div:nth-child(3) > div > div.govuk-notification-banner.govuk-notification-banner--success' do
      element :heading, 'div.govuk-notification-banner__content > h3.govuk-notification-banner__heading'
      element :message, 'div.govuk-notification-banner__content > p.govuk-body'
    end
  end
end
