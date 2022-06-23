@pipeline
Feature: Annual contract value validations

  Scenario Outline: Validations on the input
    Given I sign in and navigate to my account for 'RM6232'
    And I have an empty procurement for entering requirements named 'My empty procurement'
    When I navigate to the procurement 'My empty procurement'
    Then I am on the 'Further service and contract requirements' page
    And I click on 'Annual contract value'
    And I am on the 'Annual contract value' page
    And I enter '<annual_contract_value>' for annual contract value
    And I click on 'Save and return'
    Then I should see the following error messages:
      | <error_message> |

    Examples:
      | annual_contract_value | error_message                                                               |
      |                       | The annual contract value must be a whole number greater than 0             |
      | text                  | The annual contract value must be a whole number greater than 0             |
      | 0                     | The annual contract value must be a whole number greater than 0             |
      | 1000000000000         | The annual contract value must be less than 1,000,000,000,000 (1 trillion)  |
      | 56.9                  | The annual contract value must be a whole number greater than 0             |
