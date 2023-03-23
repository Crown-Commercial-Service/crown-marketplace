Feature: Changing contract name validations

  Scenario Outline: Validate contract name
    Given I sign in and navigate to my account for 'RM3830'
    And I have an empty procurement for entering requirements named 'My empty procurement'
    And I have a procurement with the name 'Taken contract name'
    When I navigate to the procurement 'My empty procurement'
    Then I am on the 'Requirements' page
    And I click on 'Contract name'
    Then I am on the 'Contract name' page
    And I enter '<contract_name>' into the contract name field
    And I click on 'Save and return'
    Then I should see the following error messages:
      | <error_message> |

    Examples:
      | contract_name       | error_message                         |
      |                     | Enter your contract name              |
      | Taken contract name | This contract name is already in use  |