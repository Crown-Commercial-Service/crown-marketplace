Feature: Review completed buildings

  Background:
    Given I sign in and navigate to my account for 'RM3830'
    And I have buildings
    And I click on 'Manage my buildings'
    Then I am on the 'Buildings' page
    And I click on 'Test building'
    Then I am on the buildings summary page for 'Test building'

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
