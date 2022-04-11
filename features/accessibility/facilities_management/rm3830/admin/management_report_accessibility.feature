@accessibility @javascript @management_report
Feature: Management report - accessibility

  Background: Navigate to the management report
    Given I sign in as an admin and navigate to the 'RM3830' dashboard
    And I click on 'Management report'
    Then I am on the 'Generate management report' page

  Scenario: Management report page
    Then the page should be axe clean

  Scenario: Management report show page
    Given I enter 'yesterday' as the 'From' date
    And I enter 'today' as the 'To' date
    And I click on 'Generate and download report'
    Then I am on the 'Management report' page
    Then the page should be axe clean