@accessibility @javascript
Feature: Assigning services to buildings accessibility

  Background: I navigate to the assigning services to buildings summary page
    Given I sign in and navigate to my account for 'RM6232'
    And I have buildings
    And I have an empty procurement with buildings named 'S & B procurement' with the following servcies:
      | E.1   |
      | N.5   |
      | I.1   |
      | L.3   |
      | R.1   |
    When I navigate to the procurement 'S & B procurement'
    Then I am on the 'Further service and contract requirements' page
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
      | Mechanical and Electrical Engineering Maintenance |
      | Routine cleaning                                  |
      | Helpdesk Services                                 |
    And I click on 'Save and return'
    Then I am on the 'Assigning services to buildings summary' page
    Given I click on 'Test London building' 
    Then I am on the 'Test London building' page
    And I am on the page with secondary heading 'Which of your services are required within this building?'
    When I select the service 'Flag flying service' for the building
    And I click on 'Save and return'
    Then I am on the 'Assigning services to buildings summary' page
    Then the page should be axe clean
