module SpecSupport
  module VisitStartPages
    def visit_supply_teachers_start
      visit '/supply-teachers'
      click_on 'Start now'
    end

    def visit_facilities_management_start
      visit '/facilities-management'
      click_on 'Start now'
    end

    def visit_management_consultancy_start
      visit '/management-consultancy'
      click_on 'Start now'
    end

    def visit_legal_services_start
      visit '/legal-services'
      click_on 'Start now'
    end
  end
end

RSpec.configure do |config|
  config.include SpecSupport::VisitStartPages, type: :feature

  Capybara.javascript_driver = :selenium
end
