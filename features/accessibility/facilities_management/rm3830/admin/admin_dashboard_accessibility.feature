@accessibility @javascript
Feature: Admin dashboard - accessibility

  Scenario: Dashboard page
    Given I sign in as an admin and navigate to my dashboard
    Then the page should be axe clean