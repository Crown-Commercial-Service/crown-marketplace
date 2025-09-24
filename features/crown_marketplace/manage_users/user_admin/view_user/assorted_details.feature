Feature: Manage users - User admin - View user - Assorted Details

  Background: Navigate to manage users page
    Given I sign in as an 'user admin' user go to the crown marketplace dashboard
    When I click on 'Manage users'
    Then I am on the 'Manage users' page
    Then I should not see users table
    Given I am going to do a search to find users

  Scenario Outline: View Buyer - Different confirmation status
    And I search for 'buyer@test.com' and there is a user with the following details:
      | Email verified      | true                  |
      | Account enabled     | true                  |
      | Confirmation status | <confirmation_status> |
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
      | Email address           | buyer@test.com                        |
      | Email status            | Verified                              |
      | Account status          | Enabled                               |
      | Confirmation status     | <confirmation_status>                 |
      | Mobile telephone number | None                                  |
      | Roles                   | Buyer                                 |
      | Service access          | Facilities Management, Legal Services |

    Examples:
      | confirmation_status   |
      | UNCONFIRMED           |
      | CONFIRMED             |
      | RESET_REQUIRED        |
      | FORCE_CHANGE_PASSWORD |

  Scenario: View Buyer - Things are disabled
    And I search for 'buyer@test.com' and there is a user with the following details:
      | Email verified          | false       |
      | Account enabled         | false       |
      | Confirmation status     | confirmed   |
      | Mobile telephone number | 07987654321 |
      | MFA enabled             | false       |
      | Roles                   | buyer       |
      | Service access          | mc_access   |
    And I enter 'buyer@test.com' into the search
    And I click on 'Search'
    Then I should see the following users in the results:
      | buyer@test.com | Enabled |
    And I view the user with email 'buyer@test.com'
    Then I am on the 'View user' page
    And I can manage the user
    And the user has the following details:
      | Email address           | buyer@test.com         |
      | Email status            | Unverified             |
      | Account status          | Disabled               |
      | Confirmation status     | confirmed              |
      | Mobile telephone number | 07987654321            |
      | MFA status              | Disabled               |
      | Roles                   | Buyer                  |
      | Service access          | Management Consultancy |

  Scenario: View Super admin - Has everything
    And I search for 'super_admin@test.com' and there is a user with the following details:
      | Email verified          | true                                                              |
      | Account enabled         | true                                                              |
      | Confirmation status     | confirmed                                                         |
      | Mobile telephone number | 07123456789                                                       |
      | MFA enabled             | true                                                              |
      | Roles                   | buyer,ccs_employee,allow_list_access,ccs_user_admin,ccs_developer |
      | Service access          | fm_access,mc_access,ls_access,st_access                           |
    And I enter 'super_admin@test.com' into the search
    And I click on 'Search'
    Then I should see the following users in the results:
      | super_admin@test.com | Enabled |
    And I view the user with email 'super_admin@test.com'
    Then I am on the 'View user' page
    And I cannot manage the user and there is the following warning:
      | You cannot make changes to this user. 'Super admins' can only be updated in the AWS Cognito console. |
    And the user has the following details:
      | Email address           | super_admin@test.com                                                           |
      | Email status            | Verified                                                                       |
      | Account status          | Enabled                                                                        |
      | Confirmation status     | confirmed                                                                      |
      | Mobile telephone number | 07123456789                                                                    |
      | MFA status              | Enabled                                                                        |
      | Roles                   | Buyer, Service admin, User support, User admin, Super admin                    |
      | Service access          | Facilities Management, Management Consultancy, Legal Services, Supply Teachers |
