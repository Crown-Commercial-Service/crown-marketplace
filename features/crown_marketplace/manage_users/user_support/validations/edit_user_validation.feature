Feature: Manage users - User support - Edit user - Validations

  Background: Navigate to the user show page
    Given I sign in as an 'user support' user go to the crown marketplace dashboard
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

  Scenario: Service access - Validations
    And I change the 'Service access' for the user
    And I am on the 'Update user service access' page
    And I deselect the following items:
      | Facilities Management |
      | Legal Services        |
    And I click on 'Save and return'
    Then I should see the following error messages:
      | You must select the service access for the user if they have the buyer or service admin role |

  Scenario: Service error
    And I change the 'Service access' for the user
    And I am on the 'Update user service access' page
    And I cannot update the user account because of an error
    And I click on 'Save and return'
    Then I should see the following error messages:
      | An error occured when trying to update the user |
