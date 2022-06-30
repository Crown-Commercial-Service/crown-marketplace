Feature: Services

  @javascript @pipeline
  Scenario: Select services
    Given I sign in and navigate to my account for 'RM6232'
    And I have an empty procurement for entering requirements named 'My services procurement'
    When I navigate to the procurement 'My services procurement'
    Then I am on the 'Further service and contract requirements' page
    And I click on 'Services'
    Then I am on the 'Services summary' page
    Then I click on 'Change'
    Then I am on the 'Services' page
    And I click on 'Remove all'
    And I show all sections
    Then the basket should say 'No services selected'
    And the remove all link should not be visible
    When I select 'Building Management System (BMS) maintenance'
    Then the basket should say '1 service selected'
    And the remove all link should not be visible
    And the following items should appear in the basket:
      | Building Management System (BMS) maintenance  |
    When I select the following items:
      | Water Hygiene Maintenance                     |
      | Pest control Services                         |
      | High Voltage (HV) and switchgear maintenance  |
      | Additional support Services                   |
      | Courier booking and distribution services     |
      | Patrols (fixed or static guarding)            |
    Then the basket should say '7 services selected'
    And the remove all link should be visible
    And the following items should appear in the basket:
      | Building Management System (BMS) maintenance  |
      | Water Hygiene Maintenance                     |
      | Pest control Services                         |
      | High Voltage (HV) and switchgear maintenance  |
      | Additional support Services                   |
      | Courier booking and distribution services     |
      | Patrols (fixed or static guarding)            |
    When I select all for 'Visitor Support Services'
    Then the basket should say '12 services selected'
    And the following items should appear in the basket:
      | Building Management System (BMS) maintenance  |
      | Water Hygiene Maintenance                     |
      | Pest control Services                         |
      | High Voltage (HV) and switchgear maintenance  |
      | Additional support Services                   |
      | Courier booking and distribution services     |
      | Patrols (fixed or static guarding)            |
      | Reception Service                             |
      | Taxi booking Service                          |
      | Car park management and booking               |
      | Voice announcement system operation           |
      | Concierge Services                            |
    When I remove the following items from the basket:
      | Taxi booking Service |
    Then select all 'should not' be checked for 'Visitor Support Services'
    When I select 'Taxi booking Service'
    Then select all 'should' be checked for 'Visitor Support Services'
    And I click on 'Save and return'
    Then I am on the 'Services summary' page
    And the summary should say 12 servcies selected
    And I should see the following seleceted services in the summary:
      | Building Management System (BMS) maintenance  |
      | High Voltage (HV) and switchgear maintenance  |
      | Water Hygiene Maintenance                     |
      | Pest control Services                         |
      | Courier booking and distribution services     |
      | Additional support Services                   |
      | Reception Service                             |
      | Taxi booking Service                          |
      | Car park management and booking               |
      | Voice announcement system operation           |
      | Concierge Services                            |
      | Patrols (fixed or static guarding)            |
    And I click on 'Return to requirements'
    Then I am on the 'Further service and contract requirements' page
    And 'Services' should have the status 'COMPLETED' in 'Services and buildings'
    When I click on 'Services'
    Then I am on the 'Services summary' page

  Scenario: Change selected services
    Given I sign in and navigate to my account for 'RM6232'
    And I have an empty procurement for entering requirements named 'My services procurement' with the following servcies:
      | E.1 |
      | E.2 |
      | E.3 |
    When I navigate to the procurement 'My services procurement'
    Then I am on the 'Further service and contract requirements' page
    And 'Services' should have the status 'COMPLETED' in 'Services and buildings'
    And I click on 'Services'
    Then I am on the 'Services summary' page
    And the summary should say 3 servcies selected
    And I should see the following seleceted services in the summary:
      | Mechanical and Electrical Engineering Maintenance     |
      | Ventilation and air conditioning systems maintenance  |
      | Environmental cleaning service                        |
    And I click on 'Change'
    Then I am on the 'Services' page
    When I deselect the following items:
      | Ventilation and air conditioning systems maintenance  |
      | Environmental cleaning service                        |
    And I click on 'Save and return'
    Then I am on the 'Services summary' page
    And the summary should say 1 servcie selected
    And I should see the following seleceted services in the summary:
      | Mechanical and Electrical Engineering Maintenance |
  
  Scenario: Return links work
    Given I sign in and navigate to my account for 'RM6232'
    And I have an empty procurement for entering requirements named 'My services procurement'
    When I navigate to the procurement 'My services procurement'
    Then I am on the 'Further service and contract requirements' page
    And I click on 'Services'
    Then I am on the 'Services' page
    And I click on 'Return to requirements'
    Then I am on the 'Further service and contract requirements' page
    And 'Services' should have the status 'COMPLETED' in 'Services and buildings'
