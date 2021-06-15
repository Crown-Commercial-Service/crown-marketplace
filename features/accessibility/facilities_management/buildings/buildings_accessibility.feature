@accessibility @javascript
Feature: Buildings

  Background:
    Given I sign in and navigate to my account for 'RM3830'
    And I have buildings
    And I click on 'Manage my buildings'
    Then I am on the 'Buildings' page

  Scenario: Buildings page
    Then the page should be axe clean

  Scenario: Building details simmary page
    And I click on 'Test building'
    Then the page should be axe clean

  Scenario: Add buildings
    And I click on 'Test building'
    And I change the 'Name'
    Then I am on the 'Building details' page
    Then the page should be axe clean

  Scenario: Add address manually
    And I click on 'Test building'
    And I change the 'Name'
    Then I am on the 'Building details' page
    And I change my building address
    And I enter the following details into the form:
      | Postcode  | ST16 1AA  |
    And I click on 'Find address'
    And I click on 'I can’t find my building’s address in the list'
    Then I am on the 'Add building address' page

  Scenario: Building area
    And I click on 'Test building'
    And I change the 'Gross internal area'
    Then I am on the 'Internal and external areas' page
    Then the page should be axe clean

  Scenario: Building type
    And I click on 'Test building'
    And I change the 'Building type'
    Then I am on the 'Building type' page
    Then the page should be axe clean

  Scenario: Security type
    And I click on 'Test building'
    And I change the 'Security clearance'
    Then I am on the 'Security clearance' page
    Then the page should be axe clean