@accessibility @javascript
Feature: Quick view results accessibility

  Background: Navigate to select services
    Given I sign in and navigate to my account for 'RM3830'
    And I click on 'Quick view suppliers'
    Then I am on the 'Services' page
    And I show all sections

  Scenario: Select services page
    Then the page should be axe clean

  Scenario: Select regions page
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
    Then the page should be axe clean

  Scenario: Quick view restuls page
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
    Then the page should be axe clean

  Scenario: Quick view procurement
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
    Then I enter 'Colony 6 procurement' into the contract name field
    And I click on 'Save and return to procurements dashboard'
    Then I am on the 'Procurements dashboard' page
    Then I click on 'Colony 6 procurement'
    And I am on the 'Quick view results' page
    Then the page should be axe clean
