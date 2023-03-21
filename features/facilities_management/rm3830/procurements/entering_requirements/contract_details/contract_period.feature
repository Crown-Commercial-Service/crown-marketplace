Feature: Contract period

  Background: Navigate to the contract period page
    Given I sign in and navigate to my account for 'RM3830'
    And I have an empty procurement for entering requirements named 'My empty procurement'
    When I navigate to the procurement 'My empty procurement'
    Then I am on the 'Requirements' page
    And I click on 'Contract period'
    And I am on the 'Contract period' page

  Scenario Outline: Without tupe or optional extension period
    Given I enter an inital call-off period start date 2 years and 3 months into the future
    Then I enter '<years>' years and '<months>' months for the contract period
    And I select 'No' for mobilisation period required
    And I select 'No' for optional extension required
    When I click on 'Save and return'
    Then I am on the 'Contract period summary' page
    And my inital call off period length is '<initial_call_off_period_length>'
    And my inital call off period is correct given the contract start date
    And mobilisation period length is 'None'
    And there are no optional call off extensions
    Given I click on 'Return to requirements'
    Then I am on the 'Requirements' page
    And 'Contract period' should have the status 'COMPLETED' in 'Contract details'

    Examples:
      | years | months  | initial_call_off_period_length  |
      | 0     | 1       | 1 month                         |
      | 1     | 0       | 1 year                          |
      | 1     | 3       | 1 year and 3 months             |
      | 4     | 1       | 4 years and 1 month             |
      | 2     | 8       | 2 years and 8 months            |

  Scenario: I change the contract date
    Given I enter an inital call-off period start date 1 years and 0 months into the future
    Then I enter '4' years and '8' months for the contract period
    And I select 'No' for mobilisation period required
    And I select 'No' for optional extension required
    When I click on 'Save and return'
    Then I am on the 'Contract period summary' page
    And my inital call off period length is '4 years and 8 months'
    And my inital call off period is correct given the contract start date
    And mobilisation period length is 'None'
    And there are no optional call off extensions
    Given I click on 'Change'
    And I am on the 'Contract period' page
    Then I enter '1' years and '0' months for the contract period
    And I select 'Yes' for mobilisation period required
    Then I enter '18' weeks for the mobilisation period
    When I click on 'Save and return'
    Then I am on the 'Contract period summary' page
    And my inital call off period length is '1 year'
    And my inital call off period is correct given the contract start date
    And mobilisation period length is '18 weeks'
    And the mobilisation period is correct given the contract start date
    And there are no optional call off extensions
    When I click on 'Return to requirements'
    And I am on the 'Requirements' page
    Then 'Contract period' should have the status 'COMPLETED' in 'Contract details'
    And I click on 'Contract period'
    Then I am on the 'Contract period summary' page

  Scenario: With tupe and 1 optional extension period
    Given I enter an inital call-off period start date 1 years and 8 months into the future
    Then I enter '3' years and '2' months for the contract period
    And I select 'Yes' for mobilisation period required
    Then I enter '1' weeks for the mobilisation period
    And I select 'Yes' for optional extension required
    And only the first optional extension is required
    Then I enter '2' years and '3' months for optional extension 1
    When I click on 'Save and return'
    Then I am on the 'Contract period summary' page
    And my inital call off period length is '3 years and 2 months'
    And my inital call off period is correct given the contract start date
    And mobilisation period length is '1 week'
    And the mobilisation period is correct given the contract start date
    And the length of extension period 1 is '2 years and 3 months'
    And  extension period 1 is correct given the contract start date

  @javascript
  Scenario: With tupe and 4 optional extension periods
    Given I enter an inital call-off period start date 2 years and 1 months into the future
    Then I enter '2' years and '7' months for the contract period
    And I select 'Yes' for mobilisation period required
    Then I enter '6' weeks for the mobilisation period
    And I select 'Yes' for optional extension required
    Then I enter '0' years and '1' months for optional extension 1
    And I add another extension
    Then I enter '1' years and '0' months for optional extension 2
    And I add another extension
    Then I enter '1' years and '2' months for optional extension 3
    And I add another extension
    Then I enter '3' years and '7' months for optional extension 4
    When I click on 'Save and return'
    Then I am on the 'Contract period summary' page
    And my inital call off period length is '2 years and 7 months'
    And my inital call off period is correct given the contract start date
    And mobilisation period length is '6 weeks'
    And the mobilisation period is correct given the contract start date
    And the length of extension period 1 is '1 month'
    And  extension period 1 is correct given the contract start date
    And the length of extension period 2 is '1 year'
    And  extension period 2 is correct given the contract start date
    And the length of extension period 3 is '1 year and 2 months'
    And  extension period 3 is correct given the contract start date
    And the length of extension period 4 is '3 years and 7 months'
    And  extension period 4 is correct given the contract start date

  Scenario: The return links work
    Given I click on 'Return to requirements'
    Then I am on the 'Requirements' page
    And 'Contract period' should have the status 'NOT STARTED' in 'Contract details'
