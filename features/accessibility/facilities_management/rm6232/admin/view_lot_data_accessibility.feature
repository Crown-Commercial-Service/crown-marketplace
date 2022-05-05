@accessibility @javascript
Feature: View lot data - accessibility

  Background: Navigate to the Supplier lot data
    Given I sign in as an admin and navigate to the 'RM6232' dashboard
    Then I click on 'Supplier data'
    Then I am on the 'Supplier data' page
    Then I click on 'View lot data' for 'Heidenreich Inc'
    And I am on the 'View lot data' page
    And the supplier name shown is 'Heidenreich Inc'

  Scenario: Regions page
    And I change the 'regions' for lot 'c'
    Then I am on the 'Lot c regions' page
    And the supplier name shown is 'Heidenreich Inc'
    Then the page should be axe clean

  Scenario: Services page
    And I change the 'services' for lot 'c'
    Then I am on the 'Lot c services' page
    And the supplier name shown is 'Heidenreich Inc'
    Then the page should be axe clean
