Feature: Estimated annual cost validations

  Background: Navigate to the estimated annual cost page
    Given I sign in and navigate to my account for 'RM3830'
    And I have an empty procurement for entering requirements named 'My empty procurement'
    When I navigate to the procurement 'My empty procurement'
    Then I am on the 'Requirements' page
    And I click on 'Estimated annual cost'
    And I am on the 'Estimated annual cost' page

  Scenario: Nothing is selected
    Given I click on 'Save and return'
    Then I should see the following error messages:
      | Select one option |

  Scenario Outline: Yes is selected - validations on the input
    Given I select 'Yes' for estimated annual cost known
    And I enter '<estimated_annual_cost>' for estimated annual cost
    And I click on 'Save and return'
    Then I should see the following error messages:
      | <error_message> |

    Examples:
      | estimated_annual_cost | error_message                                                                   |
      |                       | The estimated annual cost must be an amount of money, such as £12,000 or £1,200 |
      | text                  | The estimated annual cost must be an amount of money                            |
      | 0                     | The estimated annual cost must be an amount of money, such as £12,000 or £1,200 |
      | 1000000000            | Estimated annual cost must be a number between 1 and 999,999,999                |
      | 56.9                  | Estimated annual cost must be a number between 1 and 999,999,999                |