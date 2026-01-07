Feature: Information about your requirements validations

  Background: Navigate to the Information about your requirements page
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
    Then I am on the 'Annual contract cost' page
    And I enter '100000' for the annual contract cost
    And I click on 'Continue'
    Then I am on the 'Information about your requirements' page

  Scenario Outline: Validations for the estimated contract start date
    And I enter '<value>' for the contract start date
    And I enter '27' for the estimated contract duration
    And I choose the 'Yes' radio button
    And I click on 'Continue'
    Then I should see the following error messages:
      | <error_message> |

    Examples:
      | value      | error_message                                  |
      | / / /      | Enter a real date, for example 25 12 2027      |
      | yesterday  | The estimated start date must be in the future |
      | 29/02/2026 | Enter a real date, for example 25 12 2027      |
      | a/b/c      | Enter a real date, for example 25 12 2027      |

  Scenario Outline: Validations for the estimated contract duration
    And I enter 'tomorrow' for the contract start date
    And I enter '<value>' for the estimated contract duration
    And I choose the 'Yes' radio button
    And I click on 'Continue'
    Then I should see the following error messages:
      | <error_message> |

    Examples:
      | value | error_message                                                         |
      |       | The estimated contract duration must be a whole number greater than 0 |
      | 0     | The estimated contract duration must be a whole number greater than 0 |
      | a     | The estimated contract duration must be a whole number greater than 0 |
      | 1.6   | The estimated contract duration must be a whole number greater than 0 |

 Scenario: Validations for the PFI
    And I enter 'tomorrow' for the contract start date
    And I enter '27' for the estimated contract duration
    And I click on 'Continue'
    Then I should see the following error messages:
      | Select one option for requirements linked to PFI |
