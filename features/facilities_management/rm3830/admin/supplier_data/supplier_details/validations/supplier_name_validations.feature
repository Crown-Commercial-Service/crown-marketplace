Feature: Supplier name - validations

  Background: Navigate to the supplier name section
    Given I sign in as an admin and navigate to the 'RM3830' dashboard
    And I click on 'Supplier details'
    Then I am on the 'Supplier details' page
    And I click on 'Abbott-Dooley'
    Then I am on the 'Supplier details' page
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
      | Bernier-Cassin  | A supplier with this name already exists  |