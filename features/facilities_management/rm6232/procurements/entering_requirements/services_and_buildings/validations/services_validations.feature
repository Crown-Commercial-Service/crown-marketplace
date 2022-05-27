@pipeline
Feature: Services validations

  Background: Navigate to the services page
    Given I sign in and navigate to my account for 'RM6232'
    And I have an empty procurement for entering requirements named 'My services procurement'
    When I navigate to the procurement 'My services procurement'
    Then I am on the 'Further service and contract requirements' page
    And I click on 'Services'
    Then I am on the 'Services summary' page
    Then I click on 'Change'
    Then I am on the 'Services' page
    And I deselect all checkboxes

  Scenario: No services selected
    And I click on 'Save and return'
    Then I should see the following error messages:
      | Select at least one service you need to include in your procurement |

  Scenario Outline: Only one of the extra services is selected
    Given I select '<service>'
    And I click on 'Save and return'
    Then I should see the following error messages:
      | You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works' |

  Examples:
    | service                       |
    | CAFM system                   |
    | Helpdesk Services             |
    | Management of Billable Works  |

  Scenario Outline: Only two of the extra services are selected
    Given I select the following items:
      | <service_1> |
      | <service_2> |
    And I click on 'Save and return'
    Then I should see the following error messages:
      | You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works' |
  
   Examples:
    | service_1                     | service_2                     |
    | CAFM system                   | Helpdesk Services             |
    | Helpdesk Services             | Management of Billable Works  |
    | Management of Billable Works  | CAFM system                   |
  
  Scenario: Only CAFM system, Helpdesk services and Management of billable works
    Given I select the following items:
      | CAFM system                   |
      | Helpdesk Services             |
      | Management of Billable Works  |
    And I click on 'Save and return'
    Then I should see the following error messages:
      | You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works' |

