@accessibility @javascript
Feature: Supplier dashboard - accessibility

  Scenario: Supplier dashboard - no contracts
    Given I sign in as a supplier and navigate to my account
    Then the page should be axe clean

  Scenario: Supplier dashboard - many contracts
    Given I sign in as a supplier and navigate to my account and there are contracts
    Then the page should be axe clean