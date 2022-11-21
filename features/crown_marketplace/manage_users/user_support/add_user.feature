@allow_list
Feature: Manage users - User support - Add user

  Background: Navigate to add user page
    Given I sign in as an 'user support' user go to the crown marketplace dashboard
    When I click on 'Invite a new user'
    Then I am on the 'Add a user' page
    And the legend is 'Select the service access for the user'
    And the 'role' in the summary is:
      | Buyer |

  @pipeline
  Scenario: Create a Buyer user
    And I select 'Facilities Management'
    Then I click on 'Continue'
    And I am on the 'Add a user' page
    And the 'role' in the summary is:
      | Buyer |
    And the 'service access' in the summary is:
      | Facilities Management |
    And I do not have an existing user in cognito with email 'name@example.com'
    And I enter the following details into the form:
      | Email address           | name@example.com    |
    Then I click on 'Continue'
    And I am on the 'Add a user' page
    And the 'role' in the summary is:
      | Buyer |
    And the 'service access' in the summary is:
      | Facilities Management |
    And the 'email' in the summary is:
      | name@example.com  |
    And I am able to create a user account with:
      | role              | Buyer                 |
      | service access    | Facilities Management |
      | email             | name@example.com      |
    Then I click on 'Create user account'
    And I am on the 'Crown Marketplace dashboard' page
    And the account 'name@example.com' has been added

  Scenario: Change the service access
    And I select 'Legal Services'
    And I select 'Management Consultancy'
    Then I click on 'Continue'
    And I am on the 'Add a user' page
    And the 'role' in the summary is:
      | Buyer |
    And the 'service access' in the summary is:
      | Legal Services          |
      | Management Consultancy  |
    And I do not have an existing user in cognito with email 'name@example.com'
    And I enter the following details into the form:
      | Email address           | name@example.com    |
    Then I click on 'Continue'
    And I am on the 'Add a user' page
    And the 'role' in the summary is:
      | Buyer |
    And the 'service access' in the summary is:
      | Legal Services          |
      | Management Consultancy  |
    And the 'email' in the summary is:
      | name@example.com  |
    And I change the 'service access' from the user summary
    Then I am on the 'Add a user' page
    And the legend is 'Select the service access for the user'
    Then I click on 'Continue'
    And the 'role' in the summary is:
      | Buyer |
    Then I click on 'Continue'
    And I am on the 'Add a user' page
    And the 'role' in the summary is:
      | Buyer |
    And the 'service access' in the summary is:
      | Legal Services          |
      | Management Consultancy  |
    And I change the 'service access' from the user summary
    And I select 'Supply Teachers'
    Then I click on 'Continue'
    And I am on the 'Add a user' page
    And the 'role' in the summary is:
      | Buyer |
    And the 'service access' in the summary is:
      | Legal Services          |
      | Management Consultancy  |
      | Supply Teachers         |

  Scenario: Change the user detail access
    And I select 'Facilities Management'
    Then I click on 'Continue'
    And I am on the 'Add a user' page
    And the 'role' in the summary is:
      | Buyer |
    And the 'service access' in the summary is:
      | Facilities Management |
    And I do not have an existing user in cognito with email 'name@example.com'
    And I enter the following details into the form:
      | Email address           | name@example.com    |
    Then I click on 'Continue'
    And I am on the 'Add a user' page
    And the 'role' in the summary is:
      | Buyer |
    And the 'service access' in the summary is:
      | Facilities Management |
    And the 'email' in the summary is:
      | name@example.com  |
    And I change the 'email' from the user summary
    And I am on the 'Add a user' page
    And the 'role' in the summary is:
      | Buyer |
    And I enter the following details into the form:
      | Email address | name@test.com |
    And I do not have an existing user in cognito with email 'name@test.com'
    Then I click on 'Continue'
    And I am on the 'Add a user' page
    And the 'role' in the summary is:
      | Buyer |
    And the 'service access' in the summary is:
      | Facilities Management |
    And the 'email' in the summary is:
      | name@test.com |
