Feature: Quick view results
  
  Background: Navigate to quick view results
    Given I sign in and navigate to my account for 'RM3830'
    And I click on 'Quick view suppliers'
    Then I am on the 'Services' page
    And I show all sections
    And I select the following items:
      | Water hygiene maintenance                     |
      | Pest control services                         |
      | High voltage (HV) and switchgear maintenance  |
      | Administrative support services               |
      | Courier booking and external distribution     |
      | Patrols (fixed or static guarding)            |
    And I click on 'Continue'
    Then I am on the 'Regions' page
    And I show all sections
    When I select the following items:
      | Essex                                                                         |
      | Lancashire                                                                    |
      | Inner London - West                                                           |
      | Gwynedd                                                                       |
      | Inner London - East                                                           |
      | East Lothian and Midlothian                                                   |
      | Outer Belfast (Carrickfergus, Castlereagh, Lisburn, Newtownabbey, North Down) |
    And I click on 'Continue'
    And I am on the 'Quick view results' page

  Scenario: Correct selection on quick view results
    Then 6 'services' are slected
    And the following 'services' are in the drop down:
      | High voltage (HV) and switchgear maintenance  |
      | Water hygiene maintenance                     |
      | Pest control services                         |
      | Courier booking and external distribution     |
      | Administrative support services               |
      | Patrols (fixed or static guarding)            |
    Then 7 'regions' are slected
    And the following 'regions' are in the drop down:
      | Lancashire                                                                    |
      | Essex                                                                         |
      | Inner London - West                                                           |
      | Inner London - East                                                           |
      | Gwynedd                                                                       |
      | East Lothian and Midlothian                                                   |
      | Outer Belfast (Carrickfergus, Castlereagh, Lisburn, Newtownabbey, North Down) |

  @javascript
  Scenario: Hide and show requirements
    Then the requirements 'should' be visible
    And I click on 'Hide requirements'
    Then the requirements 'should not' be visible
    And I click on 'Show requirements'
    Then the requirements 'should' be visible

  Scenario: Save and return goes to the dashboard
    Then I enter 'Colony 9 procurement' into the contract name field
    And I click on 'Save and return to procurements dashboard'
    Then I am on the 'Procurements dashboard' page
    And the procurement 'Colony 9 procurement' is on the dashboard
    And the procurement 'Colony 9 procurement' should have the state 'Quick view'
    Then I click on 'Colony 9 procurement'
    And I am on the 'Quick view results' page
    And the contract name on the quick search results page is shown to be 'Colony 9 procurement'

  Scenario: Save and continue and then cancel
    Then I enter 'New LA contract' into the contract name field
    And I click on 'Save and continue to procurement'
    Then I am on the 'What happens next' page
    And I click on 'Cancel and return to procurements dashboard'
    Then I am on the 'Procurements dashboard' page
    And the procurement 'New LA contract' is on the dashboard
    And the procurement 'New LA contract' should have the state 'Quick view'
    Then I click on 'New LA contract'
    And I am on the 'Quick view results' page
    And the contract name on the quick search results page is shown to be 'New LA contract'

  Scenario: Save and continue to entering requirements
    Then I enter 'Alba Cavanich search' into the contract name field
    And I click on 'Save and continue to procurement'
    Then I am on the 'What happens next' page
    And I click on 'Continue'
    Then I am on the 'Requirements' page
    And the contract name is shown to be 'Alba Cavanich search'
    And I click on 'Return to procurements dashboard'
    And the procurement 'Alba Cavanich search' is on the dashboard
    And the procurement 'Alba Cavanich search' should have the state 'Entering requirements'

  Scenario: Contract name and service selection saved in requirements
    Then I enter 'Mechonis field contract' into the contract name field
    And I click on 'Save and continue to procurement'
    Then I am on the 'What happens next' page
    And I click on 'Continue'
    Then I am on the 'Requirements' page
    And the contract name is shown to be 'Mechonis field contract'
    And 'Contract name' should have the status 'COMPLETED' in 'Contract details'
    And 'Services' should have the status 'Completed' in 'Services and buildings'
    And I click on 'Services'
    Then I am on the 'Services summary' page
    And I should see the following seleceted services in the summary:
      | High voltage (HV) and switchgear maintenance  |
      | Water hygiene maintenance                     |
      | Pest control services                         |
      | Courier booking and external distribution     |
      | Administrative support services               |
      | Patrols (fixed or static guarding)            |
