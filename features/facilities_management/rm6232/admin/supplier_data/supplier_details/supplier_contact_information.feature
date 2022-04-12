Feature: Supplier contact information

  Scenario: Changing the contact information
    Given I sign in as an admin and navigate to the 'RM6232' dashboard
    And I click on 'Supplier data'
    Then I am on the 'Supplier data' page
    Then I click on 'View details' for 'Abshire, Schumm and Farrell'
    And I am on the 'Supplier details' page
    And the supplier name on the details page is 'Abshire, Schumm and Farrell'
    And I change the 'Contact name' for the supplier details
    Then I am on the 'Supplier contact information' page
    Given I enter 'Bana' into the 'Contact name' field
    And I enter 'argentum.enquiries@noppontrade.com' into the 'Contact email' field
    And I enter '01603 456 871' into the 'Contact telephone number' field
    And I click on 'Save and return'
    Then I am on the 'Supplier details' page
    And the 'Contact name' is 'Bana' on the supplier details page
    And the 'Contact email' is 'argentum.enquiries@noppontrade.com' on the supplier details page
    And the 'Contact telephone number' is '01603 456 871' on the supplier details page
