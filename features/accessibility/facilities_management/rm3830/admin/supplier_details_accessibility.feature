@accessibility @javascript
Feature: Supplier details - accessibility

  Background: Navigate to the supplier
    Given I sign in as an admin and navigate to the 'RM3830' dashboard
    Then I click on 'Supplier details'
    Then I am on the 'Supplier details' page

  Scenario: Supplier details page
    Then the page should be axe clean

  Scenario: Supplier detail page
    And I click on 'Abbott-Dooley'
    Then I am on the 'Supplier details' page
    Then the page should be axe clean
