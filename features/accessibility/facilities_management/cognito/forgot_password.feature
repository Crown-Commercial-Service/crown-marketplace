@accessibility @javascript
Feature: Forgot my password - RM6232 - Accessibility

  Scenario: Reset password page
    When I go to the facilities management RM6232 start page
    And I am on the 'Find a facilities management supplier' page
    When I click on 'Start now'
    And I am on the 'Sign in to your account' page
    When I click on 'I’ve forgotten my password'
    Then I am on the 'Reset password' page
    Then the page should be axe clean
