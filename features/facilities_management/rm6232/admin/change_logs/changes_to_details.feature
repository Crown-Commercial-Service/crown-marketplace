Feature: Change log for supplier details

  Scenario: Changes to the supplier details are logged
    Given I sign in as an admin and navigate to the 'RM6232' dashboard
    And I click on 'Supplier data'
    Then I am on the 'Supplier data' page
    Then I click on 'View details' for 'Hudson, Spinka and Schuppe'
    And I am on the 'Supplier details' page
    And I change the 'Supplier status' for the supplier details
    Then I am on the 'Supplier status' page
    And I select 'INACTIVE' for the supplier status
    And I click on 'Save and return'
    Then I am on the 'Supplier details' page
    And I change the 'Supplier name' for the supplier details
    Then I am on the 'Supplier name' page
    And I enter 'New supplier' into the 'Supplier name' field
    And I click on 'Save and return'
    Then I am on the 'Supplier details' page
    And I change the 'DUNS number' for the supplier details
    Then I am on the 'Additional supplier information' page
    Given I enter '987654321' into the 'DUNS number' field
    Given I enter '01234567' into the 'Company registration number' field
    And I click on 'Save and return'
    Then I am on the 'Supplier details' page
    And I change the 'Full address' for the supplier details
    Then I am on the 'Supplier address' page
    And I enter the following details into the form:
      | Building and street | 112 Test street |
      | Town or city        | Westminister    |
      | Postcode            | AB2 3DF         |
    And I click on 'Save and return'
    Then I am on the 'Supplier details' page
    And I click on 'Home'
    Then I am on the 'RM6232 administration dashboard' page
    And I click on 'Supplier data change log'
    Then I am on the 'Supplier data change log' page
    And I should see 5 logs
    And log number 1 has the user 'me'
    And log number 1 has the change type 'Details'
    And log number 2 has the user 'me'
    And log number 2 has the change type 'Details'
    And log number 3 has the user 'me'
    And log number 3 has the change type 'Details'
    And log number 4 has the user 'me'
    And log number 4 has the change type 'Details'
    And I click on log number 4
    Then I am on the 'Changes to supplier details' page
    And the supplier who was changed is 'Hudson, Spinka and Schuppe'
    And the change was made by 'me'
    And I should see the following changes to the supplier details:
      | Status | ACTIVE | INACTIVE |
    Then I click on 'Supplier data change log'
    And I am on the 'Supplier data change log' page
    And I click on log number 3
    Then I am on the 'Changes to supplier details' page
    And the supplier who was changed is 'New supplier'
    And the change was made by 'me'
    And I should see the following changes to the supplier details:
      | Supplier name | Hudson, Spinka and Schuppe | New supplier |
    Then I click on 'Supplier data change log'
    And I am on the 'Supplier data change log' page
    And I click on log number 2
    Then I am on the 'Changes to supplier details' page
    And the supplier who was changed is 'New supplier'
    And the change was made by 'me'
    And I should see the following changes to the supplier details:
      | DUNS number                 | 257625002 | 987654321 |
      | Company registration number | 0390189   | 01234567  |
    Then I click on 'Supplier data change log'
    And I am on the 'Supplier data change log' page
    And I click on log number 1
    Then I am on the 'Changes to supplier details' page
    And the supplier who was changed is 'New supplier'
    And the change was made by 'me'
    And I should see the following changes to the supplier details:
      | Building and street | 161 Christian Crossing | 112 Test street |
      | Town or city        | North Mosesside        | Westminister    |
      | Postcode            | W3 8BJ                 | AB2 3DF         |
