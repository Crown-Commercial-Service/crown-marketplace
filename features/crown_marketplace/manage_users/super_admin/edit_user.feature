Feature: Manage users - Super admin - Edit user

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

  Scenario: Edit user - Email Status
    And I change the 'Email status' for the user
    And I am on the 'Update user email status' page
    And the users details after the update will be:
      | Email verified | false  |
    And I am going to succesfully update the user on 'email_verified'
    And I choose 'UNVERIFIED' for the email status
    And I click on 'Save and return'
    Then I am on the 'View user' page
    And the user has the following details:
      | Email status  | Unverified  |

  Scenario: Edit user - Account status
    And I change the 'Account status' for the user
    And I am on the 'Update user account status' page
    And the users details after the update will be:
      | Account status | false |
    And I am going to succesfully update the user on 'account_status'
    And I choose 'Disabled' for the account status
    And I click on 'Save and return'
    Then I am on the 'View user' page
    And the user has the following details:
      | Account status | Disabled |

  Scenario: Edit user - Telephone number
    And I change the 'Mobile telephone number' for the user
    And I am on the 'Update user mobile telephone number' page
    And the users details after the update will be:
      | Mobile telephone number | 07123456789 |
    And I am going to succesfully update the user on 'telephone_number'
    And I enter the following details into the form:
      | Mobile telephone number | 07123456789 |
    And I click on 'Save and return'
    Then I am on the 'View user' page
    And the user has the following details:
      | Mobile telephone number | 07123456789 |
      | MFA status              | Disabled    |

  Scenario: Edit user - MFA Status
    And the users details after the update will be:
      | Mobile telephone number | 07123456789 |
    And I refresh the page
    And the user has the following details:
      | Mobile telephone number | 07123456789 |
      | MFA status              | Disabled    |
    And I change the 'MFA status' for the user
    And I am on the 'Update user MFA status' page
    And the users details after the update will be:
      | MFA enabled | true  |
    And I am going to succesfully update the user on 'mfa_enabled'
    And I choose 'ENABLED' for the MFA status
    And I click on 'Save and return'
    Then I am on the 'View user' page
    And the user has the following details:
      | MFA status  | Enabled  |

  Scenario: Edit user - Roles
    And I change the 'Roles' for the user
    And I am on the 'Update user roles' page
    And I have the following options for roles:
      | Buyer         |
      | Service admin |
      | User support  |
      | User admin    |
    And the users details after the update will be:
      | Mobile telephone number | 07123456789   |
      | MFA enabled             | true          |
      | Roles                   | ccs_employee  |
    And I am going to succesfully update the user on 'roles'
    And I deselect the following items:
      | Buyer |
    And I select 'Service admin'
    And I click on 'Save and return'
    Then I am on the 'View user' page
    And the user has the following details:
      | Roles | Service admin  |

  Scenario: Edit user - Service access
    And I change the 'Service access' for the user
    And I am on the 'Update user service access' page
    And the users details after the update will be:
      | Service access  | fm_access,st_access |
    And I am going to succesfully update the user on 'service_access'
    And I deselect the following items:
      | Legal Services |
    And I select 'Supply Teachers'
    And I click on 'Save and return'
    Then I am on the 'View user' page
    And the user has the following details:
      | Service access  | Facilities Management Supply Teachers  |

  Scenario: Edit user - Service error
    And I cannot edit the user account because of an error
    And I change the 'Service access' for the user
    Then I am on the 'Crown Marketplace dashboard' page
    And there is an error notification with the message 'An error occured when trying to edit the user'
