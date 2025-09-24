Feature: Change log for supplier lot status

  Scenario: Changes to the supplier services are logged
    Given I sign in as an admin and navigate to the 'RM6232' dashboard
    And I click on 'Supplier data'
    Then I am on the 'Supplier data' page
    Then I click on 'View lot data' for 'Schmeler Inc'
    And I change the 'lot status' for lot '1c'
    Then I am on the 'Lot 1c status' page
    And I select 'INACTIVE' for the lot status
    And I click on 'Save and return'
    And I am on the 'View lot data' page
    And I change the 'lot status' for lot '3c'
    Then I am on the 'Lot 3c status' page
    And I select 'INACTIVE' for the lot status
    And I click on 'Save and return'
    And I am on the 'View lot data' page
    And I change the 'lot status' for lot '1c'
    Then I am on the 'Lot 1c status' page
    And I select 'ACTIVE' for the lot status
    And I click on 'Save and return'
    And I am on the 'View lot data' page
    And I click on 'Home'
    Then I am on the 'RM6232 administration dashboard' page
    And I click on 'Supplier data change log'
    Then I am on the 'Supplier data change log' page
    And I should see 4 logs
    And log number 1 has the user 'me'
    And log number 1 has the change type 'Lot status'
    And log number 2 has the user 'me'
    And log number 1 has the change type 'Lot status'
    And log number 3 has the user 'me'
    And log number 1 has the change type 'Lot status'
    And I click on log number 3
    Then I am on the 'Changes to supplier lot data status' page
    And the supplier who was changed is 'Schmeler Inc'
    And the change was made by 'me'
    And the change was made in lot '1c'
    And I should see the following changes to the lot status:
      | ACTIVE | INACTIVE |
    Then I click on 'Supplier data change log'
    And I am on the 'Supplier data change log' page
    And I click on log number 2
    Then I am on the 'Changes to supplier lot data status' page
    And the supplier who was changed is 'Schmeler Inc'
    And the change was made by 'me'
    And the change was made in lot '3c'
    And I should see the following changes to the lot status:
      | ACTIVE | INACTIVE |
    Then I click on 'Supplier data change log'
    And I am on the 'Supplier data change log' page
    And I click on log number 1
    Then I am on the 'Changes to supplier lot data status' page
    And the supplier who was changed is 'Schmeler Inc'
    And the change was made by 'me'
    And the change was made in lot '1c'
    And I should see the following changes to the lot status:
      | INACTIVE | ACTIVE |
