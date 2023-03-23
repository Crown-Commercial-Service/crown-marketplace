Feature: Internal and external area validations

  Background: Internal and external area page
    Given I sign in and navigate to my account for 'RM3830'

  Scenario: Updating the area will change in buildings
    Given I have a procurement in detailed search named 'Area procurement' with the following services:
      | C.1 |
      | G.5 |
    And I navigate to the service requirements page
    Then the volume for 'Mechanical and electrical engineering maintenance' is 1002
    Then the volume for 'Cleaning of external areas' is 4596
    And I choose to answer the service volume question for 'Mechanical and electrical engineering maintenance'
    Then I am on the Internal and external areas page in service requirements
    And I enter '198' for the building 'GIA'
    And I enter '257' for the building 'external area'
    And I click on 'Save and return'
    Then the volume for 'Mechanical and electrical engineering maintenance' is 198
    Then the volume for 'Cleaning of external areas' is 257
    Then I navigate to the building summary page for 'Test building'
    And my building's 'Gross internal area' is '198'
    And my building's 'External area' is '257'

  Scenario: When internal area is 0 there is an error message
    Given I have a procurement in detailed search named 'Area procurement' with the following services:
      | C.1 |
      | C.3 |
    And the GIA for 'Test building' is 0
    When I navigate to the service requirements page
    Then I should see the following error messages:
      | Gross internal area must be greater than 0  |
    And the service 'Mechanical and electrical engineering maintenance' should have the error message 'Gross internal area must be greater than 0'
    And the service 'Environmental cleaning service' should have the error message 'Gross internal area must be greater than 0'
    And the building should have the status 'INCOMPLETE'

  Scenario: When external area is 0 there is an error message
    Given I have a procurement in detailed search named 'Area procurement' with the following services:
      | G.5 |
    And the external area for 'Test building' is 0
    When I navigate to the service requirements page
    Then I should see the following error messages:
      | External area must be greater than 0  |
    And the service 'Cleaning of external areas' should have the error message 'External area must be greater than 0'
    And the building should have the status 'INCOMPLETE'

  Scenario: The return links navigate back to Service requirements
    Given I have a procurement in detailed search named 'Area procurement' with the following services:
      | C.1 |
      | G.5 |
    And I navigate to the service requirements page
    And I choose to answer the service volume question for 'Mechanical and electrical engineering maintenance'
    Then I am on the Internal and external areas page in service requirements
    Given I click on the 'Return to service requirements' return link
    Then I am on the page with secondary heading 'Service requirements'
    And I choose to answer the service volume question for 'Cleaning of external areas'
    Then I am on the Internal and external areas page in service requirements
    Given I click on the 'Return to service requirements' back link
    Then I am on the page with secondary heading 'Service requirements'