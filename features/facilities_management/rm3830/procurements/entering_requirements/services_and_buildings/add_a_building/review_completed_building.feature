Feature: Review completed buildings in entering requirements

  Background:
    Given I sign in and navigate to my account for 'RM3830'
    And I have buildings
    And I have an empty procurement for entering requirements named 'My buildings procurement'
    When I navigate to the procurement 'My buildings procurement'
    Then I am on the 'Requirements' page
    And I click on 'Buildings'
    Then I am on the 'Buildings' page
    And I click on the details for 'Test building'
    Then I am on the buildings summary page for 'Test building'

  Scenario: Check the building data
    And my building's 'Name' is 'Test building'
    And my building's 'Description' is 'non-json description'
    And my building's 'Address' is '17 Sailors road, Floor 2, Southend-On-Sea SS84 6VF'
    And my building's 'Gross internal area' is '1,002'
    And my building's 'External area' is '4,596'
    And my building's 'Building type' is 'General office - customer facing'
    And my building's 'Security clearance' is 'Baseline personnel security standard (BPSS)'
    And my building's status is 'COMPLETED'

  Scenario: Change links
    And I change the 'Name'
    Then I am on the 'Building details' page
    And I click on 'Save and return to building details summary'
    Then I am on the buildings summary page for 'Test building'
    And I change the 'Description'
    Then I am on the 'Building details' page
    And I click on 'Save and return to building details summary'
    Then I am on the buildings summary page for 'Test building'
    And I change the 'Address'
    Then I am on the 'Building details' page
    And I click on 'Save and return to building details summary'
    Then I am on the buildings summary page for 'Test building'
    And I change the 'Gross internal area'
    Then I am on the 'Internal and external areas' page
    And I click on 'Save and return to building details summary'
    Then I am on the buildings summary page for 'Test building'
    And I change the 'External area'
    Then I am on the 'Internal and external areas' page
    And I click on 'Save and return to building details summary'
    Then I am on the buildings summary page for 'Test building'
    And I change the 'Building type'
    Then I am on the 'Building type' page
    And I click on 'Save and return to building details summary'
    Then I am on the buildings summary page for 'Test building'
    And I change the 'Security clearance'
    Then I am on the 'Security clearance' page
    And I click on 'Save and return to building details summary'
    Then I am on the buildings summary page for 'Test building'

  Scenario: Return links
    And I change the 'Security clearance'
    Then I am on the 'Security clearance' page
    And I click on 'Return to building type'
    Then I am on the 'Building type' page
    And I click on 'Return to building size'
    Then I am on the 'Internal and external areas' page
    And I click on 'Return to building details'
    Then I am on the 'Building details' page
    And I click on 'Return to building details summary'
    Then I am on the buildings summary page for 'Test building'
    And I click on the 'Return to buildings' back link
    Then I am on the 'Buildings' page
    And I click on the 'Return to requirements' back link
    Then I am on the 'Requirements' page
