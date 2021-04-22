@accessibility @javascript
Feature: Add a building in requirements accessibility

  Background:
    Given I sign in and navigate to my account
    Given I have buildings
    And I have an empty procurement for entering requirements named 'My buildings procurement'
    When I navigate to the procurement 'My buildings procurement'
    Then I am on the 'Requirements' page
    And I click on 'Buildings'
    Then I am on the 'Buildings' page
    And I click on the details for 'Test building'
    Then I am on the buildings summary page for 'Test building'

  Scenario: Building details summary page
    Then the page should be axe clean

  Scenario: Add buildings
    And I change the 'Name'
    Then I am on the 'Building details' page
    Then the page should be axe clean

  Scenario: Add address manually
    And I change the 'Name'
    Then I am on the 'Building details' page
    And I change my building address
    And I enter the following details into the form:
      | Postcode  | ST16 1AA  |
    And I click on 'Find address'
    And I click on 'I can’t find my building’s address in the list'
    Then I am on the 'Add building address' page

  Scenario: Building area
    And I change the 'Gross internal area'
    Then I am on the 'Internal and external areas' page
    Then the page should be axe clean

  Scenario: Building type
    And I change the 'Building type'
    Then I am on the 'Building type' page
    Then the page should be axe clean

  Scenario: Security type
    And I change the 'Security clearance'
    Then I am on the 'Security clearance' page
    Then the page should be axe clean
