@accessibility @javascript
Feature: Assigning services to buildings accessibility

  Background: I navigate to the assigning services to buildings summary page
    Given I sign in and navigate to my account
    And I have buildings
    And I have an empty procurement with buildings named 'S & B procurement' with the following servcies:
      | C.1   |
      | L.5   |
      | G.1   |
      | J.3   |
      | N.1   |
    When I navigate to the procurement 'S & B procurement'
    Then I am on the 'Requirements' page
    And I click on 'Assigning services to buildings'
    Then I am on the 'Assigning services to buildings summary' page

  Scenario: Assigning services to buildings summary page
    Then the page should be axe clean

  Scenario: Select services page
    Given I click on 'Test building' 
    Then I am on the 'Test building' page
    Then the page should be axe clean

  Scenario: Completed service selection
    Given I click on 'Test building' 
    Then I am on the 'Test building' page
    And I am on the page with secondary heading 'Which of your services are required within this building?'
    When I select the following services for the building:
      | Mechanical and electrical engineering maintenance |
      | Routine cleaning                                  |
      | Helpdesk services                                 |
    And I click on 'Save and return'
    Then I am on the 'Assigning services to buildings summary' page
    Given I click on 'Test London building' 
    Then I am on the 'Test London building' page
    And I am on the page with secondary heading 'Which of your services are required within this building?'
    When I select the service 'Flag flying service' for the building
    And I click on 'Save and return'
    Then I am on the 'Assigning services to buildings summary' page
    Then the page should be axe clean
