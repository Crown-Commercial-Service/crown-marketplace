Feature: Supplier status

  Background: Sign in
    Given I sign in as an admin and navigate to the 'RM6232' dashboard

  Scenario: Changing the supplier status is saved
    And I click on 'Supplier data'
    Then I am on the 'Supplier data' page
    Then I click on 'View details' for 'Hudson, Spinka and Schuppe'
    And I am on the 'Supplier details' page
    And the supplier name on the details page is 'Hudson, Spinka and Schuppe'
    And the 'Supplier status' is 'ACTIVE' on the supplier details page
    And I change the 'Supplier status' for the supplier details
    Then I am on the 'Supplier status' page
    And I select 'INACTIVE' for the supplier status
    And I click on 'Save and return'
    Then I am on the 'Supplier details' page
    And the 'Supplier status' is 'INACTIVE' on the supplier details page

  # TODO: Add feature when quick view has been developed
  