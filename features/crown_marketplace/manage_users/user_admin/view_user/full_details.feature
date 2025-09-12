Feature: Manage users - User admin - View user - Full Details

  Background: Navigate to manage users page
    Given I sign in as an 'user admin' user go to the crown marketplace dashboard
    When I click on 'Manage users'
    Then I am on the 'Manage users' page
    Then I should not see users table
    Given I am going to do a search to find users

  Scenario: View Buyer - Full details
    And I search for 'buyer@test.com' and there is a user with the following details:
      | Email verified      | true                |
      | Account enabled     | true                |
      | Confirmation status | confirmed           |
      | Roles               | buyer               |
      | Service access      | fm_access,ls_access |
    And I enter 'buyer@test.com' into the search
    And I click on 'Search'
    Then I should see the following users in the results:
      | buyer@test.com | Enabled |
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
      | Service access          | Facilities Management, Legal Services |

  Scenario: View Service admin - Full details
    And I search for 'service_admin@test.com' and there is a user with the following details:
      | Email verified          | true         |
      | Account enabled         | true         |
      | Confirmation status     | confirmed    |
      | Mobile telephone number | 07987654321  |
      | MFA enabled             | true         |
      | Roles                   | ccs_employee |
      | Service access          | mc_access    |
    And I enter 'service_admin@test.com' into the search
    And I click on 'Search'
    Then I should see the following users in the results:
      | service_admin@test.com | Enabled |
    And I view the user with email 'service_admin@test.com'
    Then I am on the 'View user' page
    And I can manage the user
    And the user has the following details:
      | Email address           | service_admin@test.com |
      | Email status            | Verified               |
      | Account status          | Enabled                |
      | Confirmation status     | confirmed              |
      | Mobile telephone number | 07987654321            |
      | MFA status              | Enabled                |
      | Roles                   | Service admin          |
      | Service access          | Management Consultancy |

  Scenario: View User support - Full details
    And I search for 'user_support@test.com' and there is a user with the following details:
      | Email verified          | true              |
      | Account enabled         | true              |
      | Confirmation status     | confirmed         |
      | Mobile telephone number | 07123456789       |
      | MFA enabled             | true              |
      | Roles                   | allow_list_access |
    And I enter 'user_support@test.com' into the search
    And I click on 'Search'
    Then I should see the following users in the results:
      | user_support@test.com | Enabled |
    And I view the user with email 'user_support@test.com'
    Then I am on the 'View user' page
    And I can manage the user
    And the user has the following details:
      | Email address           | user_support@test.com |
      | Email status            | Verified              |
      | Account status          | Enabled               |
      | Confirmation status     | confirmed             |
      | Mobile telephone number | 07123456789           |
      | MFA status              | Enabled               |
      | Roles                   | User support          |
      | Service access          | None                  |

  Scenario: View User admin - Full details
    And I search for 'user_admin@test.com' and there is a user with the following details:
      | Email verified          | true           |
      | Account enabled         | true           |
      | Confirmation status     | confirmed      |
      | Mobile telephone number | 07123456789    |
      | MFA enabled             | true           |
      | Roles                   | ccs_user_admin |
    And I enter 'user_admin@test.com' into the search
    And I click on 'Search'
    Then I should see the following users in the results:
      | user_admin@test.com | Enabled |
    And I view the user with email 'user_admin@test.com'
    Then I am on the 'View user' page
    And I cannot manage the user and there is the following warning:
      | You do not have the required permissions to make changes to this user. You must have the 'Super admin' role to make changes. |
    And the user has the following details:
      | Email address           | user_admin@test.com |
      | Email status            | Verified            |
      | Account status          | Enabled             |
      | Confirmation status     | confirmed           |
      | Mobile telephone number | 07123456789         |
      | MFA status              | Enabled             |
      | Roles                   | User admin          |
      | Service access          | None                |

  Scenario: View Super admin - Full details
    And I search for 'super_admin@test.com' and there is a user with the following details:
      | Email verified          | true          |
      | Account enabled         | true          |
      | Confirmation status     | confirmed     |
      | Mobile telephone number | 07123456789   |
      | MFA enabled             | true          |
      | Roles                   | ccs_developer |
    And I enter 'super_admin@test.com' into the search
    And I click on 'Search'
    Then I should see the following users in the results:
      | super_admin@test.com | Enabled |
    And I view the user with email 'super_admin@test.com'
    Then I am on the 'View user' page
    And I cannot manage the user and there is the following warning:
      | You cannot make changes to this user. 'Super admins' can only be updated in the AWS Cognito console. |
    And the user has the following details:
      | Email address           | super_admin@test.com |
      | Email status            | Verified             |
      | Account status          | Enabled              |
      | Confirmation status     | confirmed            |
      | Mobile telephone number | 07123456789          |
      | MFA status              | Enabled              |
      | Roles                   | Super admin          |
      | Service access          | None                 |
