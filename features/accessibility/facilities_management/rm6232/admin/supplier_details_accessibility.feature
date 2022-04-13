@accessibility @javascript
Feature: Supplier details - accessibility

  Background: Navigate to the supplier
    Given I sign in as an admin and navigate to the 'RM6232' dashboard
    And I click on 'Supplier data'
    Then I am on the 'Supplier data' page
    Then I click on 'View details' for 'Abshire, Schumm and Farrell'
    And I am on the 'Supplier details' page
    And the supplier name on the details page is 'Abshire, Schumm and Farrell'

  Scenario: Supplier detail page
    Then the page should be axe clean

  Scenario: Supplier status page
    And I change the 'Supplier status' for the supplier details
    Then I am on the 'Supplier status' page
    Then the page should be axe clean

  Scenario: Supplier name page
    And I change the 'Supplier name' for the supplier details
    Then I am on the 'Supplier name' page
    Then the page should be axe clean

  Scenario: Supplier contact information page
    And I change the 'Contact name' for the supplier details
    Then I am on the 'Supplier contact information' page
    Then the page should be axe clean

  Scenario: Additional supplier information page
    And I change the 'DUNS number' for the supplier details
    Then I am on the 'Additional supplier information' page
    Then the page should be axe clean

  Scenario: Full address page
    And I change the 'Full address' for the supplier details
    Then I am on the 'Supplier address' page
    Then the page should be axe clean
