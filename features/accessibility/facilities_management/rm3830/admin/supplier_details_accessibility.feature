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

  Scenario: Current user page
    And I click on 'Abbott-Dooley'
    Then I am on the 'Supplier details' page
    And I change the 'Current user' for the supplier details
    Then I am on the 'Supplier user account' page
    Then the page should be axe clean

  Scenario: Supplier name page
    And I click on 'Abbott-Dooley'
    Then I am on the 'Supplier details' page
    And I change the 'Supplier name' for the supplier details
    Then I am on the 'Supplier name' page
    Then the page should be axe clean

  Scenario: Supplier contact information page
    And I click on 'Abbott-Dooley'
    Then I am on the 'Supplier details' page
    And I change the 'Contact name' for the supplier details
    Then I am on the 'Supplier contact information' page
    Then the page should be axe clean

  Scenario: Additional supplier information page
    And I click on 'Abbott-Dooley'
    Then I am on the 'Supplier details' page
    And I change the 'DUNS number' for the supplier details
    Then I am on the 'Additional supplier information' page
    Then the page should be axe clean

  Scenario: Full address page
    And I click on 'Abbott-Dooley'
    Then I am on the 'Supplier details' page
    And I change the 'Full address' for the supplier details
    Then I am on the 'Supplier address' page
    Then the page should be axe clean
