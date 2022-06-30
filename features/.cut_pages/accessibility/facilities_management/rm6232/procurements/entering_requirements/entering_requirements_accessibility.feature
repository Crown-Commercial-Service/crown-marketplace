@accessibility @javascript
Feature: Entering requirements accessibility

  Background: Sign in to my account
    Given I sign in and navigate to my account for 'RM6232'

  Scenario: Nothing is completed
    Given I have an empty procurement for entering requirements named 'My empty procurement'
    When I navigate to the procurement 'My empty procurement'
    Then I am on the 'Further service and contract requirements' page
    Then the page should be axe clean

  Scenario: Everything is completed
    Given I have a completed procurement for entering requirements named 'My completed procurement'
    When I navigate to the procurement 'My completed procurement'
    Then I am on the 'Further service and contract requirements' page
    And everything is completed
    Then the page should be axe clean
