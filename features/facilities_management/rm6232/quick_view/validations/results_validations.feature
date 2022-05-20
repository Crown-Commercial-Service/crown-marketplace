@pipeline
Feature: Results validations

  Background: Navigate to the Results page
    Given I sign in and navigate to my account for 'RM6232'
    And I click on 'Start a procurement'
    Then I am on the 'Start a procurement' page
    And I click on 'Continue'
    Then I am on the 'Services' page
    Then I select the following items:
      | Mechanical and Electrical Engineering Maintenance           |
    And I click on 'Continue'
    Then I am on the 'Regions' page
    Then I select the following items:
      | Essex                   |
    And I click on 'Continue'
    Then I am on the 'Annual contract value' page
    And I enter '123456' for the annual contract value
    And I click on 'Continue'
    Then I am on the 'Results' page

  Scenario Outline: Contract name is blank
    Given I click on '<save_button>'
    Then I should see the following error messages:
      | Enter your contract name  |

  Examples:
      | save_button                               |
      | Save and continue                         |
      | Save and return to procurements dashboard |

  Scenario: Contract name is taken
    Given I have an RM6232 procurement with the name 'Taken contract name'
    And I enter the following details into the form:
      | Save your search | Taken contract name |
    And I click on 'Save and continue'
    Then I should see the following error messages:
      | This contract name is already in use  |