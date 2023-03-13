Feature: Supplier details - Framework expired

  Scenario: I cannot change the supplier details
    Given the 'RM3830' framework has expired
    And I sign in as an admin and navigate to the 'RM3830' dashboard
    And I click on 'Supplier details'
    Then I am on the 'Supplier details' page
    And I click on 'Ullrich, Ratke and Botsford'
    Then I am on the 'Supplier details' page
    And I should see the following warning text:
      | The RM3830 has expired, you cannot update the supplier's details. |
    And I cannot change the supplier details
