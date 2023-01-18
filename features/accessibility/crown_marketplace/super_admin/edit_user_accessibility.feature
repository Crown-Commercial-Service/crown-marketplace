@javascript @accessibility
Feature: Manage users - Super admin - Edit user - Accessibility

  Background: Navigate to the user show page
    Given I sign in as an 'super admin' user go to the crown marketplace dashboard
    When I click on 'Manage users'
    Then I am on the 'Manage users' page
    Given I am going to do a search to find users
    And I search for 'buyer@test.com' and there is a user with the following details:
      | Email verified      | true                |
      | Account enabled     | true                |
      | Confirmation status | confirmed           |
      | Roles               | buyer               |
      | Service access      | fm_access,ls_access |
    And I enter 'buyer@test.com' into the search
    And I click on 'Search'
    Then I should see the following users in the results:
      | buyer@test.com  | Enabled   |
    And I view the user with email 'buyer@test.com'
    Then I am on the 'View user' page
    And I can manage the user
    And the user has the following details:
      | Email address           | buyer@test.com                        |
      | Email status            | Verified                              |
      | Account status          | Enabled                               |
      | Confirmation status     | confirmed                             |
      | Mobile telephone number | None                                  |
      | Roles                   | Buyer                                 |
      | Service access          | Facilities Management Legal Services  |

  Scenario: Email status - Accessibility
    And I change the 'Email status' for the user
    And I am on the 'Update user email status' page
    And the page should be axe clean

  Scenario: Account status - Accessibility
    And I change the 'Account status' for the user
    And I am on the 'Update user account status' page
    And the page should be axe clean

  Scenario: Telephone number - Accessibility
    And I change the 'Mobile telephone number' for the user
    And I am on the 'Update user mobile telephone number' page
    And the page should be axe clean

  Scenario: MFA Status - Accessibility
    And the users details after the update will be:
      | Mobile telephone number | 07123456789 |
    And I refresh the page
    And the user has the following details:
      | Mobile telephone number | 07123456789 |
      | MFA status              | Disabled    |
    And I change the 'MFA status' for the user
    And I am on the 'Update user MFA status' page
    And the page should be axe clean

  Scenario: Roles - Accessibility
    And I change the 'Roles' for the user
    And I am on the 'Update user roles' page
    And the page should be axe clean

  Scenario: Service access - Accessibility
    And I change the 'Service access' for the user
    And I am on the 'Update user service access' page
    And the page should be axe clean
