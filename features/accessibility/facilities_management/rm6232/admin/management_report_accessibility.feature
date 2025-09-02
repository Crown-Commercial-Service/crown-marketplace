@accessibility @javascript @management_report
Feature: Management report - accessibility

  Background: Navigate to the management report
    Given I sign in as an admin and navigate to the 'RM6232' dashboard
    And I click on 'Management report'
    Then I am on the 'Management reports' page

  Scenario: Management reports page
    Then the page should be axe clean

  Scenario: Generate a management report
    And I click on 'Generate a new management report'
    Then I am on the 'Generate a management report' page
    Then the page should be axe clean

  Scenario: Management report show page
    And I click on 'Generate a new management report'
    Then I am on the 'Generate a management report' page
    Given I enter 'yesterday' as the 'From' date
    And I enter 'today' as the 'To' date
    And I click on 'Generate report'
    Then I am on the 'Management report' page
    Then the page should be axe clean
