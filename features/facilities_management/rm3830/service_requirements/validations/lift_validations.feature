Feature: Lift validations

  Background: Navigate to lift page
    Given I sign in and navigate to my account for 'RM3830'
    And I have a procurement in detailed search named 'Lifts procurement' with the following services:
      | C.5 |
    And I navigate to the service requirements page
    And I choose to answer the service volume question for 'Lifts, hoists & conveyance systems maintenance'
    Then I am on the page with secondary heading 'Lifts, hoists & conveyance systems maintenance'

  Scenario Outline: Basic lift validations
    And I enter '<number_of_floors>' for lift number 1
    And I click on 'Save and return'
    Then I should see the following error messages:
      | <error_message> |

    Examples:
      | number_of_floors  | error_message                                                           |
      |                   | The number of floors accessed must be a whole number and greater than 0 |
      | 0                 | Enter a whole number between 1 and 999                                  |
      | 1000              | Enter a whole number between 1 and 999                                  |
      | stew              | The number of floors accessed must be a whole number and greater than 0 |

  @javascript
  Scenario: Multiple lifts multiple errors
    And I add 3 lifts
    And I enter '10' for lift number 1
    And I enter '0' for lift number 2
    And I enter '10' for lift number 3
    And I enter '' for lift number 4
    And I click on 'Save and return'
    Then I should see the following error messages:
      | Enter a whole number between 1 and 999                                  |
      | The number of floors accessed must be a whole number and greater than 0 |
    And lift 2 should have the error message 'Enter a whole number between 1 and 999'
    And lift 4 should have the error message 'The number of floors accessed must be a whole number and greater than 0'
