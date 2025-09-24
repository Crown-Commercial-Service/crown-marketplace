@management_report
Feature: Management report

  Background: Navigate to the management report page
    Given I sign in as an admin and navigate to the 'RM6232' dashboard
    And I click on 'Management report'
    Then I am on the 'Management reports' page

  Scenario: Return links work on management reports page
    Given I click on 'Home'
    Then I am on the 'RM6232 administration dashboard' page

  Scenario Outline: Return links work on management report page
    And I click on 'Generate a new management report'
    Then I am on the 'Generate a management report' page
    Given I click on '<text>'
    Then I am on the '<page>' page

    Examples:
      | text               | page                            |
      | Home               | RM6232 administration dashboard |
      | Management reports | Management reports              |

  Scenario: Able to download the management report
    And I click on 'Generate a new management report'
    Then I am on the 'Generate a management report' page
    Given I enter 'yesterday' as the 'From' date
    And I enter 'today' as the 'To' date
    And I click on 'Generate report'
    Then I am on the 'Management report' page
    And the management report has the correct date range

  Scenario: Links on the show page work
    And I click on 'Generate a new management report'
    Then I am on the 'Generate a management report' page
    Given I enter 'yesterday' as the 'From' date
    And I enter 'today' as the 'To' date
    And I click on 'Generate report'
    Then I am on the 'Management report' page
    Then I click on 'Management reports'
    Then I am on the 'Management reports' page
    And there should be 1 management reports
