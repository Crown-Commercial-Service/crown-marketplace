Feature: Service requriements
  
  Scenario: Complete service requirements 
    Given I sign in and navigate to my account
    And I have buildings
    And I have an empty procurement with buildings named 'S & B procurement' with the following servcies assigned:
      | C.1 |
      | L.5 |
      | G.1 |
      | J.3 |
      | N.1 |
    When I navigate to the procurement 'S & B procurement'
    Then I am on the 'Requirements' page
    And 'Service requirements' should have the status 'INCOMPLETE' in 'Services and buildings'
    And I click on 'Service requirements'
    Then I am on the 'Service requirements summary' page
    And the service requirements status for 'Test building' is 'INCOMPLETE'
    And the service requirements status for 'Test London building' is 'INCOMPLETE'
    When I click on 'Test building'
    Then I am on the page with secondary heading 'Service requirements'
    And the building should have the status 'INCOMPLETE'
    Given I choose to answer the service volume question for 'Routine cleaning'
    And I am on the page with secondary heading 'Routine cleaning'
    Given I enter '456' for the service volume
    And I click on 'Save and return'
    Then I am on the page with secondary heading 'Service requirements'
    And the building should have the status 'INCOMPLETE'
    Given I choose to answer the service volume question for 'Control of access and security passes'
    And I am on the page with secondary heading 'Control of access and security passes'
    And I enter '3650' for the number of hours per year
    And I enter the following for the detail of requirement:
      | This is some details of requirement |
      | And it is going over two lines      |
    And I click on 'Save and return'
    Then I am on the page with secondary heading 'Service requirements'
    And the building should have the status 'INCOMPLETE'
    Given I choose to answer the service standard question for 'Mechanical and electrical engineering maintenance'
    Then I am on the page with secondary heading 'Mechanical and electrical engineering maintenance'
    And I select Standard 'A'
    Then I click on 'Save and return'
    Then I am on the page with secondary heading 'Service requirements'
    And the building should have the status 'INCOMPLETE'
    Given I choose to answer the service standard question for 'Routine cleaning'
    Then I am on the page with secondary heading 'Routine cleaning'
    And I select Standard 'C'
    Then I click on 'Save and return'
    Then I am on the page with secondary heading 'Service requirements'
    And the building should have the status 'COMPLETE'
    Then I click on 'Return to service requirements summary'
    Then I am on the 'Service requirements summary' page
    And the service requirements status for 'Test building' is 'COMPLETED'
    And the service requirements status for 'Test London building' is 'INCOMPLETE'
    When I click on 'Test London building'
    Then I am on the page with secondary heading 'Service requirements'
    And the building should have the status 'INCOMPLETE'
    Given I choose to answer the service volume question for 'Routine cleaning'
    And I am on the page with secondary heading 'Routine cleaning'
    Given I enter '982' for the service volume
    And I click on 'Save and return'
    Then I am on the page with secondary heading 'Service requirements'
    And the building should have the status 'INCOMPLETE'
    Given I choose to answer the service volume question for 'Control of access and security passes'
    And I am on the page with secondary heading 'Control of access and security passes'
    And I enter '1234' for the number of hours per year
    And I enter the following for the detail of requirement:
      | My one line of details  |
    And I click on 'Save and return'
    Then I am on the page with secondary heading 'Service requirements'
    And the building should have the status 'INCOMPLETE'
    Given I choose to answer the service standard question for 'Mechanical and electrical engineering maintenance'
    Then I am on the page with secondary heading 'Mechanical and electrical engineering maintenance'
    And I select Standard 'B'
    Then I click on 'Save and return'
    Then I am on the page with secondary heading 'Service requirements'
    And the building should have the status 'INCOMPLETE'
    Given I choose to answer the service standard question for 'Routine cleaning'
    Then I am on the page with secondary heading 'Routine cleaning'
    And I select Standard 'B'
    Then I click on 'Save and return'
    Then I am on the page with secondary heading 'Service requirements'
    And the building should have the status 'COMPLETE'
    Then I click on 'Return to service requirements summary'
    Then I am on the 'Service requirements summary' page
    And the service requirements status for 'Test building' is 'COMPLETED'
    And the service requirements status for 'Test London building' is 'COMPLETED'
    Then I click on 'Return to requirements'
    And I am on the 'Requirements' page
    Then 'Service requirements' should have the status 'COMPLETED' in 'Services and buildings'