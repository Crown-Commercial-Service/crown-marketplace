Feature: Service hours validations

  Background: Navigate to Service hour page
    Given I sign in and navigate to my account for 'RM3830'
    And I have a procurement in detailed search named 'Service hours procurement' with the following services:
      | I.4 |
    And I navigate to the service requirements page
    And I choose to answer the service volume question for 'Voice announcement system operation'
    Then I am on the page with secondary heading 'Voice announcement system operation'

  Scenario: Both fields are empty
    And I click on 'Save and return'
    Then I should see the following error messages:
      | Enter number of hours per year  |
      | Enter the detail of requirement |

  Scenario Outline: Validations on the service hour entry
    And I enter '<service_hours>' for the number of hours per year
    And I enter the following for the detail of requirement:
      | This is some details of requirement |
    And I click on 'Save and return'
    Then I should see the following error messages:
      | <error_message> |

  Examples:
    | service_hours   | error_message                                                             |
    | 0               | Number of hours per year must be a whole number between 1 and 999,999,999 |
    | 1000000000      | Number of hours per year must be a whole number between 1 and 999,999,999 |
    | 234.5           | Number of hours per year must be a whole number between 1 and 999,999,999 |
    | Pyra            | Enter number of hours per year                                            |
