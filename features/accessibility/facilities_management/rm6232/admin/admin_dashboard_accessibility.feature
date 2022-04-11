@accessibility @javascript
Feature: Admin dashboard - accessibility

  Scenario: Dashboard page
    Given I sign in as an admin and navigate to the 'RM6232' dashboard
    Then the page should be axe clean
