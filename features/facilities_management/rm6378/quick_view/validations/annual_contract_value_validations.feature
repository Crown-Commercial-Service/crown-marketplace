Feature: Average estimated contract value validations

  Scenario Outline: validations for the Average estimated contract value
    Given I sign in and navigate to my account for 'RM6378'
    And I click on 'Search for suppliers'
    Then I am on the 'Services' page
    Then I select the following items:
      | Mechanical and Electrical Engineering Maintenance |
    And I click on 'Continue'
    Then I am on the 'Regions' page
    Then I select the following items:
      | Tees Valley |
    And I click on 'Continue'
    Then I am on the 'Average estimated contract value' page
    And I enter '<value>' for the Average estimated contract value
    And I click on 'Continue'
    Then I should see the following error messages:
      | <error_message> |

    Examples:
      | value         | error_message                                                             |
      |               | The Average estimated contract value must be a whole number greater than 0            |
      | 0             | The Average estimated contract value must be a whole number greater than 0            |
      | 1000000000000 | The Average estimated contract value must be less than 1,000,000,000,000 (1 trillion) |
      | 67.4          | The Average estimated contract value must be a whole number greater than 0            |
      | Big int       | The Average estimated contract value must be a whole number greater than 0            |
