@accessibility @javascript
Feature: Sign up to facilties management - RM6232 - Accessibility

  Scenario: Create an account page
    When I go to the facilities management RM6232 start page
    And I am on the 'Find a facilities management supplier' page
    When I click on 'Start now'
    And I am on the 'Sign in to your account' page
    And I click on 'Create an account'
    Then I am on the 'Create an account' page
    Then the page should be axe clean
