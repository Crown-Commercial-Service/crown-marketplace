Feature: Service standard validations

  Scenario: Blank service standard
    Given I sign in and navigate to my account for 'RM3830'
    And I have a procurement in detailed search named 'Service standard procurement' with the following services:
      | C.1 |
    And I navigate to the service requirements page
    And I choose to answer the service standard question for 'Mechanical and electrical engineering maintenance'
    Then I am on the page with secondary heading 'Mechanical and electrical engineering maintenance'
    And I click on 'Save and return'
    Then I should see the following error messages:
      | Select the level of standard  |
