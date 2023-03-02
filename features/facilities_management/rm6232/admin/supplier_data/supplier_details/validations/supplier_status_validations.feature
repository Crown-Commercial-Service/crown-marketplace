Feature: Supplier status - validations

  Scenario: Validate supplier status
    Given I sign in as an admin and navigate to the 'RM6232' dashboard
    And I have an inactive supplier called 'Argentum INC.'
    And I click on 'Supplier data'
    Then I am on the 'Supplier data' page
    Then I click on 'View details' for 'Argentum INC.'
    And I am on the 'Supplier details' page
    And the supplier name on the details page is 'Argentum INC.'
    And I change the 'Supplier status' for the supplier details
    Then I am on the 'Supplier status' page
    And I click on 'Save and return'
    Then I should see the following error messages:
      | You must select a status for the supplier |
