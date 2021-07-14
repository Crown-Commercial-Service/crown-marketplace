Feature: Call-off benchmark rates

  Background: Navigate to the average framework rates page
    Given I sign in as an admin and navigate to my dashboard
    And I click on 'Call-off benchmark rates'
    Then I am on the 'Call-off benchmark rates' page

  Scenario Outline: Links on the page work
    Then I click on '<return_link>'
    And I am on the 'RM3830 administration dashboard' page

  Examples:
    | return_link               |
    | Home                      |
    | Return to admin dashboard |

  Scenario: Changes are saved
    Given I enter the servie rate of '12.6' for 'Environmental cleaning service' standard 'A'
    Given I enter the servie rate of '11.54' for 'High voltage (HV) and switchgear maintenance' standard 'B'
    And I enter the servie rate of '18.6' for 'Routine cleaning' standard 'C'
    And I enter the servie rate of '0.1276' for 'Helpdesk services' standard ''
    And I enter the servie rate of '0.10098' for 'Direct award TUPE risk premium (%)'
    And I click on 'Save and return to dashboard'
    Then I am on the 'RM3830 administration dashboard' page
    And I click on 'Call-off benchmark rates'
    Then I am on the 'Call-off benchmark rates' page
    And the following services should have the following rates for their standard:
      | Environmental cleaning service                | 12.6    | A |
      | High voltage (HV) and switchgear maintenance  | 11.54   | B |
      | Routine cleaning                              | 18.6    | C |
      | Helpdesk services                             | 0.1276  |   |
    And the following services should have the following rates:
      | Direct award TUPE risk premium (%)  | 0.10098 |