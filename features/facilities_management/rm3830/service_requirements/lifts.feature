Feature: Lifts

  Background: I navigate to the lifts page
    Given I sign in and navigate to my account for 'RM3830'
    And I have a procurement in detailed search named 'Lifts procurement' with the following services:
      | C.5 |
    And I navigate to the service requirements page
    And I choose to answer the service volume question for 'Lifts, hoists & conveyance systems maintenance'
    Then I am on the page with secondary heading 'Lifts, hoists & conveyance systems maintenance'

  @javascript
  Scenario: I can add and remove lifts
    And I add 4 lifts
    Then there are 5 lift rows
    And the add lift button has text 'Add another lift (94 remaining)'
    And I enter '10' for lift number 1
    And I enter '20' for lift number 2
    And I enter '30' for lift number 3
    And I enter '20' for lift number 4
    And I enter '10' for lift number 5
    And I click on 'Save and return'
    Then I am on the page with secondary heading 'Service requirements'
    Then the volume for 'Lifts, hoists & conveyance systems maintenance' is 90
    And I choose to answer the service volume question for 'Lifts, hoists & conveyance systems maintenance'
    Then I am on the page with secondary heading 'Lifts, hoists & conveyance systems maintenance'
    And I remove a lift
    And I remove a lift
    Then there are 3 lift rows
    And the add lift button has text 'Add another lift (96 remaining)'
    And I click on 'Save and return'
    Then I am on the page with secondary heading 'Service requirements'
    Then the volume for 'Lifts, hoists & conveyance systems maintenance' is 60
    And I choose to answer the service volume question for 'Lifts, hoists & conveyance systems maintenance'
    Then I am on the page with secondary heading 'Lifts, hoists & conveyance systems maintenance'
    And I add 1 lift
    And I remove a lift
    Then there are 3 lift rows
    And I enter '46' for lift number 2
    And the add lift button has text 'Add another lift (96 remaining)'
    And I click on 'Save and return'
    Then I am on the page with secondary heading 'Service requirements'
    Then the volume for 'Lifts, hoists & conveyance systems maintenance' is 86

  Scenario: The return links navigate back to Service requirements
    Given I click on the 'Return to service requirements' return link
    Then I am on the page with secondary heading 'Service requirements'
    And I choose to answer the service volume question for 'Lifts, hoists & conveyance systems maintenance'
    Then I am on the page with secondary heading 'Lifts, hoists & conveyance systems maintenance'
    Given I click on the 'Return to service requirements' back link
    Then I am on the page with secondary heading 'Service requirements'
    