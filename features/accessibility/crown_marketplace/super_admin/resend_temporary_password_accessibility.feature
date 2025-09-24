@javascript @accessibility
Feature: Manage users - Super admin - Resend temporary password - Accessibility

  Scenario: Show page with resend temporary password link
    Given I sign in as an 'super admin' user go to the crown marketplace dashboard
    When I click on 'Manage users'
    Then I am on the 'Manage users' page
    Given I am going to do a search to find users
    And I search for 'buyer@test.com' and there is a user with the following details:
      | Email verified      | true                  |
      | Account enabled     | true                  |
      | Confirmation status | FORCE_CHANGE_PASSWORD |
      | Roles               | buyer                 |
      | Service access      | fm_access,ls_access   |
    And I enter 'buyer@test.com' into the search
    And I click on 'Search'
    Then I should see the following users in the results:
      | buyer@test.com | Enabled |
    And I view the user with email 'buyer@test.com'
    Then I am on the 'View user' page
    And I can manage the user
    And the user has the following details:
      | Confirmation status | FORCE_CHANGE_PASSWORD |
    And the resend temporary password is 'visible'
    And the page should be axe clean
