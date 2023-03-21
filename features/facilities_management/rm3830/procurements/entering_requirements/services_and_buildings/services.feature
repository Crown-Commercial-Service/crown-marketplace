Feature: Services

  @javascript
  Scenario: Select services
    Given I sign in and navigate to my account for 'RM3830'
    And I have an empty procurement for entering requirements named 'My services procurement'
    When I navigate to the procurement 'My services procurement'
    Then I am on the 'Requirements' page
    And I click on 'Services'
    Then I am on the 'Services' page
    And I show all sections
    Then the basket should say 'No services selected'
    And the remove all link should not be visible
    When I select 'Building management system (BMS) maintenance'
    Then the basket should say '1 service selected'
    And the remove all link should not be visible
    And the following items should appear in the basket:
      | Building management system (BMS) maintenance  |
    When I select the following items:
      | Water hygiene maintenance                     |
      | Pest control services                         |
      | High voltage (HV) and switchgear maintenance  |
      | Administrative support services               |
      | Courier booking and external distribution     |
      | Patrols (fixed or static guarding)            |
    Then the basket should say '7 services selected'
    And the remove all link should be visible
    And the following items should appear in the basket:
      | Building management system (BMS) maintenance  |
      | Water hygiene maintenance                     |
      | Pest control services                         |
      | High voltage (HV) and switchgear maintenance  |
      | Administrative support services               |
      | Courier booking and external distribution     |
      | Patrols (fixed or static guarding)            |
    When I select all for 'Reception services'
    Then the basket should say '11 services selected'
    And the following items should appear in the basket:
      | Building management system (BMS) maintenance  |
      | Water hygiene maintenance                     |
      | Pest control services                         |
      | High voltage (HV) and switchgear maintenance  |
      | Administrative support services               |
      | Courier booking and external distribution     |
      | Patrols (fixed or static guarding)            |
      | Reception service                             |
      | Taxi booking service                          |
      | Car park management and booking               |
      | Voice announcement system operation           |
    When I remove the following items from the basket:
      | Taxi booking service |
    Then select all 'should not' be checked for 'Reception services'
    When I select 'Taxi booking service'
    Then select all 'should' be checked for 'Reception services'
    And I click on 'Save and return'
    Then I am on the 'Services summary' page
    And the summary should say 11 servcies selected
    And I should see the following seleceted services in the summary:
      | Building management system (BMS) maintenance  |
      | High voltage (HV) and switchgear maintenance  |
      | Water hygiene maintenance                     |
      | Pest control services                         |
      | Courier booking and external distribution     |
      | Administrative support services               |
      | Reception service                             |
      | Taxi booking service                          |
      | Car park management and booking               |
      | Voice announcement system operation           |
      | Patrols (fixed or static guarding)            |
    And I click on 'Return to requirements'
    Then I am on the 'Requirements' page
    And 'Services' should have the status 'COMPLETED' in 'Services and buildings'
    When I click on 'Services'
    Then I am on the 'Services summary' page

  Scenario: Change selected services
    Given I sign in and navigate to my account for 'RM3830'
    And I have an empty procurement for entering requirements named 'My services procurement' with the following servcies:
      | C.1 |
      | C.2 |
      | C.3 |
    When I navigate to the procurement 'My services procurement'
    Then I am on the 'Requirements' page
    And 'Services' should have the status 'COMPLETED' in 'Services and buildings'
    And I click on 'Services'
    Then I am on the 'Services summary' page
    And the summary should say 3 servcies selected
    And I should see the following seleceted services in the summary:
      | Mechanical and electrical engineering maintenance   |
      | Ventilation and air conditioning system maintenance |
      | Environmental cleaning service                      |
    And I click on 'Change'
    Then I am on the 'Services' page
    When I deselect the following items:
      | Ventilation and air conditioning system maintenance |
      | Environmental cleaning service                      |
    And I click on 'Save and return'
    Then I am on the 'Services summary' page
    And the summary should say 1 servcie selected
    And I should see the following seleceted services in the summary:
      | Mechanical and electrical engineering maintenance |
  
  Scenario: Return links work
    Given I sign in and navigate to my account for 'RM3830'
    And I have an empty procurement for entering requirements named 'My services procurement'
    When I navigate to the procurement 'My services procurement'
    Then I am on the 'Requirements' page
    And I click on 'Services'
    Then I am on the 'Services' page
    And I click on 'Return to requirements'
    Then I am on the 'Requirements' page
    And 'Services' should have the status 'NOT STARTED' in 'Services and buildings'
