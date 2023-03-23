Feature: Annual contract cost validations
  
  Scenario Outline: validations for the annual contract cost
    Given I sign in and navigate to my account for 'RM6232'
    And I click on 'Search for suppliers'
    Then I am on the 'Services' page
    Then I select the following items:
      | Mechanical and Electrical Engineering Maintenance |
    And I click on 'Continue'
    Then I am on the 'Regions' page
    Then I select the following items:
      | Tees Valley and Durham  |
    And I click on 'Continue'
    Then I am on the 'Annual contract cost' page
    And I enter '<value>' for the annual contract cost
    And I click on 'Continue'
    Then I should see the following error messages:
      | <error_message> |

    Examples:
      | value         | error_message                                                             |
      |               | The annual contract cost must be a whole number greater than 0            |
      | 0             | The annual contract cost must be a whole number greater than 0            |
      | 1000000000000 | The annual contract cost must be less than 1,000,000,000,000 (1 trillion) |
      | 67.4          | The annual contract cost must be a whole number greater than 0            |
      | Big int       | The annual contract cost must be a whole number greater than 0            |
