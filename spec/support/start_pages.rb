module SpecSupport
  module VisitStartPages
    def visit_supply_teachers_start
      visit '/supply-teachers'
      click_on 'Start now'
      click_on 'Sign in with DfE Sign-in'
    end

    def visit_facilities_management_start
      visit '/facilities-management/start'
      click_on 'Start now'
      click_on 'Sign in with beta credentials'
    end

    def visit_management_consultancy_start
      visit '/'
      click_on 'Start now'
      click_on 'Sign in with beta credentials'
    end
  end
end

RSpec.configure do |config|
  config.include SpecSupport::VisitStartPages, type: :feature
end
