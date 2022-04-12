@management_report
Feature: Management report  - validations

  Background: Navigate to the management report page
    Given I sign in as an admin and navigate to the 'RM3830' dashboard
    And I click on 'Management report'
    Then I am on the 'Management report' page

  Scenario Outline: Return links work
    Given I click on '<text>'
    Then I am on the '<page>' page

    Examples:
      | text                      | page                            |
      | Home                      | RM3830 administration dashboard |
      | Management report         | Management report               |
      | Return to admin dashboard | RM3830 administration dashboard |

  Scenario: Able to download the management report
    Given I enter 'yesterday' as the 'From' date
    And I enter 'today' as the 'To' date
    And I click on 'Generate and download report'
    Then I am on the 'Management report' page
    And the management report has the correct date range

  Scenario Outline: Links on the show page work
    Given I enter 'yesterday' as the 'From' date
    And I enter 'today' as the 'To' date
    And I click on 'Generate and download report'
    Then I am on the 'Management report' page
    Then I click on '<text>'
    Then I am on the '<page>' page

    Examples:
      | text                      | page                            |
      | Generate another report   | Management report               |
      | Return to admin dashboard | RM3830 administration dashboard |
