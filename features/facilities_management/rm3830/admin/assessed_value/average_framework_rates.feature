Feature: Average framework rates

  Background: Navigate to the average framework rates page
    Given I sign in as an admin and navigate to the 'RM3830' dashboard
    And I click on 'Average framework rates'
    Then I am on the 'Average framework rates' page

  Scenario Outline: Links on the page work
    Then I click on '<return_link>'
    And I am on the 'RM3830 administration dashboard' page

  Examples:
    | return_link               |
    | Home                      |
    | Return to admin dashboard |

  Scenario: Changes are saved
    Given I enter the servie rate of '15.587' for 'D.1 Grounds maintenance services'
    Given I enter the servie rate of '13.4' for 'H.3 Courier booking and external distribution'
    And I enter the servie rate of '18.6' for 'J.5 Patrols (fixed or static guarding)'
    And I enter the servie rate of '0.32' for 'M.1 CAFM system'
    And I enter the servie rate of '0.76' for 'London location percentage variance (%)'
    And I click on 'Save and return to dashboard'
    Then I am on the 'RM3830 administration dashboard' page
    And I click on 'Average framework rates'
    Then I am on the 'Average framework rates' page
    And the following services should have the following rates:
      | D.1 Grounds maintenance services              | 15.587  |
      | H.3 Courier booking and external distribution | 13.4    |
      | J.5 Patrols (fixed or static guarding)        | 18.6    |
      | M.1 CAFM system                               | 0.32    |
      | London location percentage variance (%)       | 0.76    |

