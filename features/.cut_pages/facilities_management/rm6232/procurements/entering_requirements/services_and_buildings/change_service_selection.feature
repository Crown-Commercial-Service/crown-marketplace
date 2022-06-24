@pipeline
Feature: Changing the service selection

  Scenario: The assigning services to buildings becomes incomplete when the service selection is changed
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
    And 'Assigning services to buildings' should have the status 'INCOMPLETE' in 'Services and buildings'
    And I click on 'Assigning services to buildings'
    Then I am on the 'Assigning services to buildings summary' page
    Given I click on 'Test building' 
    Then I am on the 'Test building' page
    And I am on the page with secondary heading 'Which of your services are required within this building?'
    When I select the following services for the building:
      | Mechanical and Electrical Engineering Maintenance |
      | Routine cleaning                                  |
      | Helpdesk Services                                 |
    And I click on 'Save and return'
    Then I am on the 'Assigning services to buildings summary' page
    And the assigning services to buildings status should be 'INCOMPLETE'
    And the building named 'Test building' should say 3 services selected
    Then I open the selected services for 'Test building'
    And the following services have been selected for 'Test building':
      | Mechanical and Electrical Engineering Maintenance |
      | Routine cleaning                                  |
      | Helpdesk Services                                 |
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
    And I am on the 'Further service and contract requirements' page
    And 'Assigning services to buildings' should have the status 'COMPLETED' in 'Services and buildings'
    And I click on 'Services'
    Then I am on the 'Services summary' page
    And I click on 'Change'
    Then I am on the 'Services' page
    When I deselect the following items:
      | Mechanical and Electrical Engineering Maintenance |
      | Routine cleaning                                  |
    And I click on 'Save and return'
    Then I am on the 'Services summary' page
    And the summary should say 3 servcies selected
    And I should see the following seleceted services in the summary:
      | Control of access - Staff and Visitors  |
      | Flag flying service                     |
      | Helpdesk Services                       |
    And I click on 'Return to requirements'
    Then I am on the 'Further service and contract requirements' page
    And 'Services' should have the status 'COMPLETED' in 'Services and buildings'
    And 'Assigning services to buildings' should have the status 'INCOMPLETE' in 'Services and buildings'