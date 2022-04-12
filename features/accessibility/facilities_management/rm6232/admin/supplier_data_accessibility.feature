@accessibility @javascript
Feature: Supplier data - accessibility

  Background: Navigate to the Supplier data
    Given I sign in as an admin and navigate to the 'RM6232' dashboard
    Then I click on 'Supplier data'
    Then I am on the 'Supplier data' page

  Scenario: Supplier details page
    Then the page should be axe clean

  Scenario: Supplier detail page with search
    And I enter "a" for the supplier search
    Then the page should be axe clean

  Scenario: View lot data for supplier with one lot
    Then I click on 'View lot data' for 'Bernier, Luettgen and Bednar'
    And I am on the 'View lot data' page
    And the supplier name shown is 'Bernier, Luettgen and Bednar'
    Then the page should be axe clean

  Scenario: View lot data for supplier with multiple lots
    Then I click on 'View lot data' for 'Green Group'
    And I am on the 'View lot data' page
    And the supplier name shown is 'Green Group'
    Then the page should be axe clean
