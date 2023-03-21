Feature: Services validations

  Background: Navigate to the services page
    Given I sign in and navigate to my account for 'RM3830'
    And I have an empty procurement for entering requirements named 'My services procurement'
    When I navigate to the procurement 'My services procurement'
    Then I am on the 'Requirements' page
    And I click on 'Services'
    Then I am on the 'Services' page

  Scenario: No services selected
    And I click on 'Save and return'
    Then I should see the following error messages:
      | Select at least one service you need to include in your procurement |

  Scenario Outline: Only one of the extra services is selected
    Given I select '<service>'
    And I click on 'Save and return'
    Then I should see the following error messages:
      | <error_messages>  |

  Examples:
    | service                       | error_messages                                                                                                      |
    | CAFM system                   | You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works' |
    | Helpdesk services             | You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works' |
    | Management of billable works  | You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works' |

  Scenario Outline: Only two of the extra services are selected
    Given I select the following items:
      | <service_1> |
      | <service_2> |
    And I click on 'Save and return'
    Then I should see the following error messages:
      | <error_messages>  |
  
   Examples:
    | service_1                     | service_2                     | error_messages                                                                                                      |
    | CAFM system                   | Helpdesk services             | You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works' |
    | Helpdesk services             | Management of billable works  | You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works' |
    | Management of billable works  | CAFM system                   | You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works' |
  
  Scenario: Only CAFM system, Helpdesk services and Management of billable works
    Given I select the following items:
      | CAFM system |
      | Helpdesk services |
      | Management of billable works|
    And I click on 'Save and return'
    Then I should see the following error messages:
      | You must select another service to include 'CAFM system', 'Helpdesk services' and/or 'Management of billable works' |

