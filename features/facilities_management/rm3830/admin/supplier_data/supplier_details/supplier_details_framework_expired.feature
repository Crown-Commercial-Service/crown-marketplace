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
    And the 'Current user' is 'None' on the supplier details page
    And the 'Supplier name' is 'Ullrich, Ratke and Botsford' on the supplier details page
    And the 'Contact name' is 'Soila Provenzano' on the supplier details page
    And the 'Contact email' is 'ullrich-ratke-botsford@yopmail.com' on the supplier details page
    And the 'Contact telephone number' is '01322 682761' on the supplier details page
    And the 'DUNS number' is '921087777' on the supplier details page
    And the 'Company registration number' is '689657' on the supplier details page
    And the 'Full address' is '104 Moseley Wood Gardens, Leeds LS16 7HU' on the supplier details page
