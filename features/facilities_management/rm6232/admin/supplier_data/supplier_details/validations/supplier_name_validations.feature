Feature: Supplier name - validations

  Background: Navigate to the supplier name section
    Given I sign in as an admin and navigate to the 'RM6232' dashboard
    And I click on 'Supplier data'
    Then I am on the 'Supplier data' page
    Then I click on 'View details' for 'Torphy Inc'
    And I am on the 'Supplier details' page
    And the supplier name on the details page is 'Torphy Inc'
    And I change the 'Supplier name' for the supplier details
    Then I am on the 'Supplier name' page

  Scenario Outline: Validate supplier name
    And I enter '<supplier_name>' into the 'Supplier name' field
    And I click on 'Save and return'
    Then I should see the following error messages:
      | <error_message> |

    Examples:
      | supplier_name   | error_message                             |
      |                 | You must enter a supplier name            |
      | Satterfield LLC | A supplier with this name already exists  |