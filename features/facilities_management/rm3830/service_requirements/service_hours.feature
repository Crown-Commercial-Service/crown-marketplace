Feature: Service hours

  Background: Navigate to Service hour page
    Given I sign in and navigate to my account for 'RM3830'
    And I have a procurement in detailed search named 'Service hours procurement' with the following services:
      | I.4 |
    And I navigate to the service requirements page
    And I choose to answer the service volume question for 'Voice announcement system operation'
    Then I am on the page with secondary heading 'Voice announcement system operation'
  
  Scenario: Service hour entry saves
    And I enter '3650' for the number of hours per year
    And I enter the following for the detail of requirement:
      | This is some details of requirement |
      | And it is going over two lines      |
    And I click on 'Save and return'
    Then I am on the page with secondary heading 'Service requirements'
    Then the volume for 'Voice announcement system operation' is 3650
    And the detail of requirement for 'Voice announcement system operation' is as follows:
      | This is some details of requirement |
      | And it is going over two lines      |

  Scenario: The return links navigate back to Service requirements
    Given I click on the 'Return to service requirements' return link
    Then I am on the page with secondary heading 'Service requirements'
    And I choose to answer the service volume question for 'Voice announcement system operation'
    Then I am on the page with secondary heading 'Voice announcement system operation'
    Given I click on the 'Return to service requirements' back link
    Then I am on the page with secondary heading 'Service requirements'