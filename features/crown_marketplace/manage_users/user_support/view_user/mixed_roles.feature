Feature: Manage users - User support - View user - Mixed Roles

  Background: Navigate to manage users page
    Given I sign in as an 'user support' user go to the crown marketplace dashboard
    When I click on 'Manage users'
    Then I am on the 'Manage users' page
    Then I should not see users table
    Given I am going to do a search to find users

  Scenario: View Buyer and service admin
    And I search for 'buyer@test.com' and there is a user with the following details:
      | Email verified      | true               |
      | Account enabled     | true               |
      | Confirmation status | confirmed          |
      | Roles               | buyer,ccs_employee |
      | Service access      | fm_access          |
    And I enter 'buyer@test.com' into the search
    And I click on 'Search'
    Then I should see the following users in the results:
      | buyer@test.com | Enabled |
    And I view the user with email 'buyer@test.com'
    Then I am on the 'View user' page
    And I cannot manage the user and there is the following warning:
      | You do not have the required permissions to make changes to this user. You must have the 'User admin' role to make changes. |
    And the user has the following details:
      | Email address | buyer@test.com       |
      | Email status  | Verified             |
      | Roles         | Buyer, Service admin |

  Scenario: View Service admin and User support
    And I search for 'service_admin@test.com' and there is a user with the following details:
      | Email verified      | true                           |
      | Account enabled     | true                           |
      | Confirmation status | confirmed                      |
      | Roles               | ccs_employee,allow_list_access |
      | Service access      | fm_access                      |
    And I enter 'service_admin@test.com' into the search
    And I click on 'Search'
    Then I should see the following users in the results:
      | service_admin@test.com | Enabled |
    And I view the user with email 'service_admin@test.com'
    Then I am on the 'View user' page
    And I cannot manage the user and there is the following warning:
      | You do not have the required permissions to make changes to this user. You must have the 'User admin' role to make changes. |
    And the user has the following details:
      | Email address | service_admin@test.com      |
      | Email status  | Verified                    |
      | Roles         | Service admin, User support |

  Scenario: View User support and User admin
    And I search for 'user_support@test.com' and there is a user with the following details:
      | Email verified      | true                             |
      | Account enabled     | true                             |
      | Confirmation status | confirmed                        |
      | Roles               | allow_list_access,ccs_user_admin |
    And I enter 'user_support@test.com' into the search
    And I click on 'Search'
    Then I should see the following users in the results:
      | user_support@test.com | Enabled |
    And I view the user with email 'user_support@test.com'
    Then I am on the 'View user' page
    And I cannot manage the user and there is the following warning:
      | You do not have the required permissions to make changes to this user. You must have the 'Super admin' role to make changes. |
    And the user has the following details:
      | Email address | user_support@test.com    |
      | Email status  | Verified                 |
      | Roles         | User support, User admin |

  Scenario: View User admin and Super admin
    And I search for 'user_admin@test.com' and there is a user with the following details:
      | Email verified      | true                         |
      | Account enabled     | true                         |
      | Confirmation status | confirmed                    |
      | Roles               | ccs_user_admin,ccs_developer |
    And I enter 'user_admin@test.com' into the search
    And I click on 'Search'
    Then I should see the following users in the results:
      | user_admin@test.com | Enabled |
    And I view the user with email 'user_admin@test.com'
    Then I am on the 'View user' page
    And I cannot manage the user and there is the following warning:
      | You cannot make changes to this user. 'Super admins' can only be updated in the AWS Cognito console. |
    And the user has the following details:
      | Email address | user_admin@test.com     |
      | Email status  | Verified                |
      | Roles         | User admin, Super admin |
