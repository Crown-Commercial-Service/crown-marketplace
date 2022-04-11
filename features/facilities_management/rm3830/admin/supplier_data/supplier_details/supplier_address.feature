Feature: Supplier address

  Scenario: Changing the supplier address
    Given I sign in as an admin and navigate to the 'RM3830' dashboard
    And I click on 'Supplier details'
    Then I am on the 'Supplier details' page
    And I click on 'Abbott-Dooley'
    Then I am on the 'Supplier details' page
    And I change the 'Full address' for the supplier details
    Then I am on the 'Supplier address' page
    And I enter the following details into the form:
      | Building and street | Goldmouth Warehouse |
      | Town or city        | Argentum            |
      | Postcode            | AA1 1AA             |
    And I click on 'Save and return'
    Then I am on the 'Supplier details' page
    And the 'Full address' is 'Goldmouth Warehouse, Argentum AA1 1AA' on the supplier details page