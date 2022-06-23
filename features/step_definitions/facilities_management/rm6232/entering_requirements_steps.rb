Then('I enter {string} for annual contract cost') do |annual_contract_value|
  entering_requirements_page.annual_contract_value.set(annual_contract_value)
end
