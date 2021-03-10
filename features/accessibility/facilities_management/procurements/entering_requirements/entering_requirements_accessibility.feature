@accessibility @javascript
Feature: Entering requirements accessibility

  Background: Sign in to my account
    Given I sign in and navigate to my account

  Scenario: Nothing is completed
    Given I have an empty procurement for entering requirements named 'My empty procurement'
    When I navigate to the procurement 'My empty procurement'
    Then I am on the 'Requirements' page
    Then the page should be axe clean

  Scenario: Everything is completed
    Given I have a completed procurement for entering requirements named 'My completed procurement'
    When I navigate to the procurement 'My completed procurement'
    Then I am on the 'Requirements' page
    And everything is completed
    Then the page should be axe clean
