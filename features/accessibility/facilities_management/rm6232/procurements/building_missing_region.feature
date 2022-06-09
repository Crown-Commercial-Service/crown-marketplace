@accessibility @javascript
Feature: Buildings used in a procurement are missing a region - accessibility

  Background: Sign in and navigate to the page
    Given I sign in and navigate to my account for 'RM6232'
    And I have a completed procurement for entering requirements named 'My missing regions procurement' with buildings missing regions
    When I navigate to the procurement 'My missing regions procurement'
    Then I am on the 'Review your buildings' page

  Scenario: Review your buildings page
    Then the page should be axe clean

  Scenario: Confirm your building's region page
    Given I select region for 'Test building 1'
    Then the page should be axe clean
