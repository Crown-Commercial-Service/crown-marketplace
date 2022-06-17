Feature: Service specification
  
  Scenario: Service specification
    Given I sign in and navigate to my account for 'RM6232'
    And I have an empty procurement for entering requirements named 'My services procurement'
    When I navigate to the procurement 'My services procurement'
    Then I am on the 'Further service and contract requirements' page
    And I click on 'Services'
    Then I am on the 'Services summary' page
    Then I click on 'Change'
    Then I am on the 'Services' page
    Given I click on the service specification for '<service_name>'
    Then I am on the '<page_title>' page
    And the page sub title is 'Service specification'
    And The service name and code is '<service_name_and_code>'
    And there '<option>' generic requirements

    Examples:
      | service_name                            | page_title                                        | service_name_and_code                         | option  |
      | Water Hygiene Maintenance               | Work Package F - Statutory Obligations            | F2 - Water Hygiene Maintenance                | are     |
      | Mail Services                           | Work Package J - Workplace FM Services            | J1 - Mail Services                            | are not |
      | Rural Estate Maintenance (REM) Services | Work Package O - Specialist (Defence) FM Services | O4 - Rural Estate Maintenance (REM) Services  | are not |
      | Helpdesk Services                       | Work Package R - Helpdesk Services                | R1 – Helpdesk Services                        | are not |
