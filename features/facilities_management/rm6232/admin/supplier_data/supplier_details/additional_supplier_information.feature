Feature: Additional supplier information

  Scenario: Changing the additional supplier information
    Given I sign in as an admin and navigate to the 'RM6232' dashboard
    And I click on 'Supplier data'
    Then I am on the 'Supplier data' page
    Then I click on 'View details' for 'Abshire, Schumm and Farrell'
    And I am on the 'Supplier details' page
    And the supplier name on the details page is 'Abshire, Schumm and Farrell'
    And I change the 'DUNS number' for the supplier details
    Then I am on the 'Additional supplier information' page
    Given I enter '091876561' into the 'DUNS number' field
    And I enter 'AB123456' into the 'Company registration number' field
    And I click on 'Save and return'
    Then I am on the 'Supplier details' page
    And the 'DUNS number' is '091876561' on the supplier details page
    And the 'Company registration number' is 'AB123456' on the supplier details page
