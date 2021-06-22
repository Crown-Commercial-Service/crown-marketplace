@accessibility @javascript
Feature: Start pages accessibility

  Scenario: Start page
    When I go to the facilities management RM3830 start page
    Then I am on the 'Find a facilities management supplier' page
    Then the page should be axe clean
  
  Scenario: Sign in page
    When I go to the facilities management RM3830 start page
    And I am on the 'Find a facilities management supplier' page
    When I click on 'Start now'
    Then I am on the 'Sign in to your account' page
    Then the page should be axe clean

  Scenario: Buyer account page
    Given I sign in and navigate to my account for 'RM3830'
    Then the page should be axe clean