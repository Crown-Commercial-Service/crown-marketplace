Feature: Supplier address

  Scenario: Changing the supplier address
    Given I sign in as an admin and navigate to the 'RM6232' dashboard
    And I click on 'Supplier data'
    Then I am on the 'Supplier data' page
    Then I click on 'View details' for 'Abshire, Schumm and Farrell'
    And I am on the 'Supplier details' page
    And the supplier name on the details page is 'Abshire, Schumm and Farrell'
    And I change the 'Full address' for the supplier details
    Then I am on the 'Supplier address' page
    And I enter the following details into the form:
      | Building and street | Goldmouth Warehouse |
      | Town or city        | Argentum            |
      | County (optional)   |                     |
      | Postcode            | AA1 1AA             |
    And I click on 'Save and return'
    Then I am on the 'Supplier details' page
    And the 'Full address' is 'Goldmouth Warehouse, Argentum AA1 1AA' on the supplier details page
