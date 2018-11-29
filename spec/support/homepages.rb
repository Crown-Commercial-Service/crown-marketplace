module SpecSupport
  module VisitHomepages
    def visit_supply_teachers_home
      visit '/'
      click_on 'Sign in with beta credentials'
      click_on I18n.t('home.index.supply_teachers_link')
    end

    def visit_facilities_management_home
      visit '/'
      click_on 'Sign in with beta credentials'
      click_on I18n.t('home.index.facilities_management_link')
    end

    def visit_management_consultancy_home
      visit '/'
      click_on 'Sign in with beta credentials'
      click_on I18n.t('home.index.management_consultancy_link')
    end
  end
end

RSpec.configure do |config|
  config.include SpecSupport::VisitHomepages, type: :feature
end
