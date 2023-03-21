Feature: Supplier details - Framework expired

  Scenario: I cannot change the supplier details
    Given the 'RM6232' framework has expired
    And I sign in as an admin and navigate to the 'RM6232' dashboard
    And I click on 'Supplier data'
    Then I am on the 'Supplier data' page
    Then I click on 'View details' for 'Zboncak and Sons'
    And I am on the 'Supplier details' page
    And the supplier name on the details page is 'Zboncak and Sons'
    And I should see the following warning text:
      | The RM6232 has expired, you cannot update the supplier's details. |
    And I cannot change the supplier details
