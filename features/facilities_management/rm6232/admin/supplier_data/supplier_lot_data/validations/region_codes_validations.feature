@pipline
Feature: Selecting region codes validations

  Scenario: No region codes are selected
    Given I sign in as an admin and navigate to the 'RM6232' dashboard
    And I click on 'Supplier data'
    Then I am on the 'Supplier data' page
    Then I click on 'View lot data' for 'Pfeffer-Orn'
    And I am on the 'View lot data' page
    And the supplier name shown is 'Pfeffer-Orn'
    And I change the 'regions' for lot '1b'
    Then I am on the 'Lot 1b regions' page
    And I deselect all checkboxes
    And I click on 'Save and return'
    Then I should see the following error messages:
      | You must select at least one region for this lot  |