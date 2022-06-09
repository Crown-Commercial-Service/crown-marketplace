@pipeline
Feature: Assigning services to buildings validations

  Background: Background name
    Given I sign in and navigate to my account for 'RM6232'
    And I have buildings
    And I have an empty procurement with buildings named 'S & B procurement' with the following servcies:
      | I.1 |
      | I.4 |
      | Q.3 |
      | R.1 |
      | S.1 |
    When I navigate to the procurement 'S & B procurement'
    Then I am on the 'Further service and contract requirements' page
    And I click on 'Assigning services to buildings'
    Then I am on the 'Assigning services to buildings summary' page
    And I click on 'Test building'
    Then I am on the page with secondary heading 'Which of your services are required within this building?'

  Scenario: No services selected
    When I click on 'Save and return'
    Then I should see the following error messages:
      | You must select at least one service for this building  |

  Scenario: Both cleanings selected
    When I select the following services for the building:
      | Routine cleaning          |
      | Mobile cleaning Services  |
    And I click on 'Save and return'
    Then I should see the following error messages:
      | 'Mobile cleaning' and 'Routine cleaning' are the same, but differ by delivery method. Please choose one of these services only  |

  Scenario Outline: Only one of the extra services is selected
    Given I select the service '<service>' for the building
    And I click on 'Save and return'
    Then I should see the following error messages:
      | <error_messages>  |

  Examples:
    | service                       | error_messages                                                                                                      |
    | CAFM system                   | You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works' |
    | Helpdesk Services             | You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works' |
    | Management of Billable Works  | You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works' |

  Scenario Outline: Only two of the extra services are selected
    Given I select the following services for the building:
      | <service_1> |
      | <service_2> |
    And I click on 'Save and return'
    Then I should see the following error messages:
      | <error_messages>  |
  
   Examples:
    | service_1                     | service_2                     | error_messages                                                                                                      |
    | CAFM system                   | Helpdesk Services             | You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works' |
    | Helpdesk Services             | Management of Billable Works  | You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works' |
    | Management of Billable Works  | CAFM system                   | You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works' |
  
  Scenario: Only CAFM system, Helpdesk services and Management of billable works
    Given I select the following services for the building:
      | CAFM system                   |
      | Helpdesk Services             |
      | Management of Billable Works  |
    And I click on 'Save and return'
    Then I should see the following error messages:
      | You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works' |

