Feature: Manage users - Super admin - Resend temporary password

  Background: Navigate to the user show page
    Given I sign in as an 'super admin' user go to the crown marketplace dashboard
    When I click on 'Manage users'
    Then I am on the 'Manage users' page
    Then I should not see users table
    Given I am going to do a search to find users

  Scenario Outline: There is only a button for FORCE_CHANGE_PASSWORD
    And I search for 'buyer@test.com' and there is a user with the following details:
      | Email verified      | true                  |
      | Account enabled     | true                  |
      | Confirmation status | <confirmation_status> |
      | Roles               | buyer                 |
      | Service access      | fm_access,ls_access   |
    And I enter 'buyer@test.com' into the search
    And I click on 'Search'
    Then I should see the following users in the results:
      | buyer@test.com  | Enabled   |
    And I view the user with email 'buyer@test.com'
    Then I am on the 'View user' page
    And I can manage the user
    And the user has the following details:
      | Confirmation status | <confirmation_status> |
    And the resend temporary password is '<option>'

    Examples:
      | confirmation_status   | option      |
      | UNCONFIRMED           | not visible |
      | CONFIRMED             | not visible |
      | ARCHIVED              | not visible |
      | COMPROMISED           | not visible |
      | UNKNOWN               | not visible |
      | RESET_REQUIRED        | not visible |
      | FORCE_CHANGE_PASSWORD | visible     |

  Scenario: Reset password - Success
    And I search for 'buyer@test.com' and there is a user with the following details:
      | Email verified      | true                  |
      | Account enabled     | true                  |
      | Confirmation status | FORCE_CHANGE_PASSWORD |
      | Roles               | buyer                 |
      | Service access      | fm_access,ls_access   |
    And I enter 'buyer@test.com' into the search
    And I click on 'Search'
    Then I should see the following users in the results:
      | buyer@test.com  | Enabled   |
    And I view the user with email 'buyer@test.com'
    Then I am on the 'View user' page
    And I can manage the user
    And the user has the following details:
      | Confirmation status | FORCE_CHANGE_PASSWORD |
    And the resend temporary password is 'visible'
    And I am going to click resend temporary password which will return:
      | |
    And I click on 'Resend temporary password'
    Then I am on the 'View user' page
    And an email has been sent to 'buyer@test.com'

  Scenario: Reset password - Error
    And I search for 'buyer@test.com' and there is a user with the following details:
      | Email verified      | true                  |
      | Account enabled     | true                  |
      | Confirmation status | FORCE_CHANGE_PASSWORD |
      | Roles               | buyer                 |
      | Service access      | fm_access,ls_access   |
    And I enter 'buyer@test.com' into the search
    And I click on 'Search'
    Then I should see the following users in the results:
      | buyer@test.com  | Enabled   |
    And I view the user with email 'buyer@test.com'
    Then I am on the 'View user' page
    And I can manage the user
    And the user has the following details:
      | Confirmation status | FORCE_CHANGE_PASSWORD |
    And the resend temporary password is 'visible'
    And I am going to click resend temporary password which will return:
      | An error occured when resend the temporary password |
    And I click on 'Resend temporary password'
    Then I am on the 'View user' page
    And there is an error notification with the message 'An error occured when resend the temporary password'
