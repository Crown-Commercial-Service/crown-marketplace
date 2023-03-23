Feature: Contract period validations

  Background: Navigate to the contract period page
    Given I sign in and navigate to my account for 'RM3830'
    And I have an empty procurement for entering requirements named 'My empty procurement'
    When I navigate to the procurement 'My empty procurement'
    Then I am on the 'Requirements' page
    And I click on 'Contract period'
    And I am on the 'Contract period' page

  Scenario: All empty
    Given I click on 'Save and return'
    Then I should see the following error messages:
      | Enter the years for the initial call-off period   |
      | Enter the months for the initial call-off period  |
      | Enter a valid initial call-off start date         |
      | Select one option for mobilisation period         |
      | Select one option for call-off contract extension |

  Scenario Outline: Validating the inial call off period length
    Given I enter 'today' as the inital call-off period start date
    And I select 'No' for mobilisation period required
    And I select 'No' for optional extension required
    Then I enter '<years>' years and '<months>' months for the contract period
    When I click on 'Save and return'
    Then I should see the following error messages:
      | <error_message> |

    Examples:
      | years | months  | error_message                                                         |
      | 2     | text    | The months for the initial call-off period must be a whole number     |
      | 2     | 12      | The months for the initial call-off period must be between 0 and 11   |
      | 2     | 1.4     | The months for the initial call-off period must be a whole number     |
      | text  | 2       | The years for the initial call-off period must be a whole number      |
      | 8     | 2       | The years for the initial call-off period must be between 0 and 7     |
      | 1.5   | 2       | The years for the initial call-off period must be a whole number      |
      | 0     | 0       | The total initial call-off period must be between 1 month and 7 years |
      | 7     | 1       | The total initial call-off period must be between 1 month and 7 years |

  Scenario Outline: Validating the inial call off period date
    Given I enter '1' year and '6' months for the contract period
    And I select 'No' for mobilisation period required
    And I select 'No' for optional extension required
    Then I enter '<date>' as the inital call-off period start date
    When I click on 'Save and return'
    Then I should see the following error messages:
      | <error_message> |

    Examples:
      | date        | error_message                                                             |
      | yesterday   | Initial call-off period start date must be today or in the future         |
      | 89/45/0161  | Enter a valid initial call-off start date                                 |
      | a/b/c       | Enter a valid initial call-off start date                                 |
      | 1/1/2101    | Initial call-off period start date cannot be later than 31 December 2100  |

  Scenario Outline: Validating the mobilisation period
    Given I enter '1' year and '6' months for the contract period
    Then I enter an inital call-off period start date 1 years and 0 months into the future
    And I select 'Yes' for mobilisation period required
    And I select 'No' for optional extension required
    Then I enter '<mobilisation_period>' weeks for the mobilisation period
    When I click on 'Save and return'
    Then I should see the following error messages:
      | <error_message> |

    Examples:
      | mobilisation_period | error_message                                       |
      |                     | Enter mobilisation period length                    |
      | 0                   | Mobilisation length must be between 1 and 52 weeks  |
      | 54                  | Mobilisation length must be between 1 and 52 weeks  |
      | text                | Enter mobilisation length                           |
      | .5                  | Enter mobilisation length as a whole number         |

  Scenario: Validating the mobilisation period with tupe
    Given I click on 'Return to requirements'
    Then I am on the 'Requirements' page
    And I click on 'TUPE'
    And I am on the 'TUPE' page
    Given I select 'Yes' for TUPE required
    When I click on 'Save and return'
    Then I am on the 'Requirements' page
    And I click on 'Contract period'
    And I am on the 'Contract period' page
    Given I enter '1' year and '6' months for the contract period
    Then I enter an inital call-off period start date 1 years and 0 months into the future
    And I select 'Yes' for mobilisation period required
    And I select 'No' for optional extension required
    Then I enter '3' weeks for the mobilisation period
    When I click on 'Save and return'
    Then I should see the following error messages:
      | Mobilisation length must be a minimum of 4 weeks when TUPE is selected  |

  Scenario: Mobilisation period start date validation
    Given I enter '1' year and '6' months for the contract period
    And I enter 'today' as the inital call-off period start date
    And I select 'Yes' for mobilisation period required
    And I select 'No' for optional extension required
    Then I enter '4' weeks for the mobilisation period
    When I click on 'Save and return'
    Then I should see the following error messages:
      | Mobilisation start date must be in the future, please review your 'Initial call-off-period' and 'Mobilisation period length'  |

  Scenario Outline: Optional call off periods basic validations
    Given I enter '4' year and '8' months for the contract period
    And I enter 'today' as the inital call-off period start date
    And I select 'No' for mobilisation period required
    And I select 'Yes' for optional extension required
    And only the first optional extension is required
    Then I enter '<years>' years and '<months>' months for optional extension 1
    When I click on 'Save and return'
    Then I should see the following error messages:
      | <error_message> |

    Examples:
      | years | months  | error_message                                                 |
      | 2     |         | Enter the months for the extension period                     |
      | 2     | text    | The months for the extension period must be a whole number    |
      | 2     | 12      | The months for the extension period must be between 0 and 11  |
      | 2     | 1.4     | The months for the extension period must be a whole number    |
      |       | 2       | Enter the years for the extension period                      |
      | text  | 2       | The years for the extension period must be a whole number     |
      | 1.5   | 2       | The years for the extension period must be a whole number     |
      | 0     | 0       | The total for extension period 1 must be greater than 1 month |

  @javascript
  Scenario: All optional call offs are validated
    Given I enter '4' year and '8' months for the contract period
    And I enter 'today' as the inital call-off period start date
    And I select 'No' for mobilisation period required
    And I select 'Yes' for optional extension required
    Then I enter '1' years and '1' months for optional extension 1
    And I add another extension
    Then I enter '1' years and '1' months for optional extension 2
    And I add another extension
    Then I enter '1' years and '1' months for optional extension 3
    And I add another extension
    Then I enter '1' years and '1' months for optional extension 4
    Then I enter '1' years and '' months for optional extension 1
    Then I enter '0' years and '0' months for optional extension 2
    Then I enter 'text' years and '' months for optional extension 3
    Then I enter '1' years and '12' months for optional extension 4
    And I remove extension period 4
    When I click on 'Save and return'
    Then I should see the following error messages:
      | Enter the months for the extension period                     |
      | The total for extension period 2 must be greater than 1 month |
      | Enter the years for the extension period                      |
    And extension 1 should have the following error messages:
      | Enter the months for the extension period |
    And extension 2 should have the following error messages:
      | The total for extension period 2 must be greater than 1 month |
    And extension 3 should have the following error messages:
      | Enter the years for the extension period  |
      | Enter the months for the extension period |
    And extension 4 should be 'hidden'

  @javascript
  Scenario: Total contract length too long - without mobilisation period
    Given I enter '4' year and '8' months for the contract period
    And I enter 'today' as the inital call-off period start date
    And I select 'No' for mobilisation period required
    And I select 'Yes' for optional extension required
    Then I enter '3' years and '2' months for optional extension 1
    And I add another extension
    Then I enter '3' years and '3' months for optional extension 2
    When I click on 'Save and return'
    Then I should see the following error messages:
      | Call-off contract period, including extensions and mobilisation period, must not be more than 10 years in total |

  @javascript
  Scenario: Total contract length too long - with mobilisation period
    Given I enter '4' year and '8' months for the contract period
    And I enter an inital call-off period start date 1 years and 0 months into the future
    And I select 'Yes' for mobilisation period required
    Then I enter '1' weeks for the mobilisation period
    And I select 'Yes' for optional extension required
    Then I enter '3' years and '2' months for optional extension 1
    And I add another extension
    Then I enter '3' years and '2' months for optional extension 2
    When I click on 'Save and return'
    Then I should see the following error messages:
      | Call-off contract period, including extensions and mobilisation period, must not be more than 10 years in total |