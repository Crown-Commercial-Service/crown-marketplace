Feature: Assigning services to buildings

  Background: I navigate to the assigning services to buildings summary page
    Given I sign in and navigate to my account for 'RM3830'
    And I have buildings
    And I have an empty procurement with buildings named 'S & B procurement' with the following servcies:
      | C.1   |
      | C.21  |
      | L.5   |
      | G.1   |
      | J.3   |
      | N.1   |
    When I navigate to the procurement 'S & B procurement'
    Then I am on the 'Requirements' page
    And 'Assigning services to buildings' should have the status 'INCOMPLETE' in 'Services and buildings'
    And I click on 'Assigning services to buildings'
    Then I am on the 'Assigning services to buildings summary' page

  Scenario: Select services for the buildings
    And the assigning services to buildings status should be 'INCOMPLETE'
    And the building named 'Test building' should have no services selected
    And the building named 'Test London building' should have no services selected
    Given I click on 'Test building' 
    Then I am on the 'Test building' page
    And I am on the page with secondary heading 'Which of your services are required within this building?'
    When I select the following services for the building:
      | Mechanical and electrical engineering maintenance |
      | Routine cleaning                                  |
      | Helpdesk services                                 |
    And I click on 'Save and return'
    Then I am on the 'Assigning services to buildings summary' page
    And the assigning services to buildings status should be 'INCOMPLETE'
    And the building named 'Test building' should say 3 services selected
    Then I open the selected services for 'Test building'
    And the following services have been selected for 'Test building':
      | Mechanical and electrical engineering maintenance |
      | Routine cleaning                                  |
      | Helpdesk services                                 |
    Given I click on 'Test London building' 
    Then I am on the 'Test London building' page
    And I am on the page with secondary heading 'Which of your services are required within this building?'
    When I select the service 'Flag flying service' for the building
    And I click on 'Save and return'
    Then I am on the 'Assigning services to buildings summary' page
    And the assigning services to buildings status should be 'COMPLETED'
    And the building named 'Test London building' should say 1 service selected
    Then I open the selected services for 'Test London building'
    And the following services have been selected for 'Test London building':
      | Flag flying service |
    Then I click on 'Return to requirements'
    And I am on the 'Requirements' page
    And 'Assigning services to buildings' should have the status 'COMPLETED' in 'Services and buildings'
    Then 'Service requirements' should have the status 'INCOMPLETE' in 'Services and buildings'

  @javascript
  Scenario: Select all services
    Given I click on 'Test building'
    Then I am on the 'Test building' page
    And I am on the page with secondary heading 'Which of your services are required within this building?'
    Given I select all services for the building
    And I click on 'Save and return'
    And the building named 'Test building' should say 6 services selected
    Then I open the selected services for 'Test building'
    And the following services have been selected for 'Test building':
      | Mechanical and electrical engineering maintenance |
      | Airport and aerodrome maintenance services        |
      | Routine cleaning                                  |
      | Control of access and security passes             |
      | Flag flying service                               |
      | Helpdesk services                                 |
    Given I click on 'Test building'
    Then I am on the 'Test building' page
    And I am on the page with secondary heading 'Which of your services are required within this building?'
    Then select all should be 'checked'
    When I deselect the service 'Flag flying service' for the building
    Then select all should be 'unchecked'
    When I select the service 'Flag flying service' for the building
    Then select all should be 'checked'

  Scenario: Only services without requirements are selected
    Given I click on 'Test building' 
    Then I am on the 'Test building' page
    And I am on the page with secondary heading 'Which of your services are required within this building?'
    When I select the service 'Airport and aerodrome maintenance services' for the building
    And I click on 'Save and return'
    Then I am on the 'Assigning services to buildings summary' page
    And the assigning services to buildings status should be 'INCOMPLETE'
    And the building named 'Test building' should say 1 service selected
    Then I open the selected services for 'Test building'
    And the following services have been selected for 'Test building':
      | Airport and aerodrome maintenance services  |
    Given I click on 'Test London building' 
    Then I am on the 'Test London building' page
    And I am on the page with secondary heading 'Which of your services are required within this building?'
    When I select the service 'Airport and aerodrome maintenance services' for the building
    And I click on 'Save and return'
    Then I am on the 'Assigning services to buildings summary' page
    And the assigning services to buildings status should be 'COMPLETED'
    And the building named 'Test London building' should say 1 service selected
    Then I open the selected services for 'Test London building'
    And the following services have been selected for 'Test London building':
      | Airport and aerodrome maintenance services |
    Then I click on 'Return to requirements'
    And I am on the 'Requirements' page
    And 'Assigning services to buildings' should have the status 'COMPLETED' in 'Services and buildings'
    Then 'Service requirements' should have the status 'NOT REQUIRED' in 'Services and buildings'

  Scenario: Return links work
    Given I click on 'Test building'
    Then I am on the 'Test building' page
    And I am on the page with secondary heading 'Which of your services are required within this building?'
    When I click on 'Return to assigning services to buildings summary page'
    Then I am on the 'Assigning services to buildings summary' page
