Feature: Create a procurement validations

  Background: Navigate to create a procurement
    Given I sign in and navigate to my account for 'RM3830'
    And I click on 'Start a procurement'
    Then I am on the 'What happens next' page
    And I click on 'Continue'
    Then I am on the 'Contract name' page

  Scenario Outline: Validate contract name
    And I have a procurement with the name 'Taken contract name'
    And I enter '<contract_name>' into the contract name field
    And I click on 'Save and continue'
    Then I should see the following error messages:
      | <error_message> |

    Examples:
      | contract_name       | error_message                         |
      |                     | Enter your contract name              |
      | Taken contract name | This contract name is already in use  |
