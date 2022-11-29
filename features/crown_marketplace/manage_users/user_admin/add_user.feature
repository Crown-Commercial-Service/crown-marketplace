Feature: Manage users - User admin - Add user

  Background: Navigate to add user page
    Given I sign in as an 'user admin' user go to the crown marketplace dashboard
    When I click on 'Invite a new user'
    Then I am on the 'Add a user' page
    And the legend is 'Select the role for the user'

  Scenario: Create a Buyer user
    Given I choose the 'Buyer' radio button
    Then I click on 'Continue'
    And I am on the 'Add a user' page
    And the 'role' in the summary is:
      | Buyer |
    And the legend is 'Select the service access for the user'
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

  Scenario: Create a Service Admin user
    Given I choose the 'Service admin' radio button
    Then I click on 'Continue'
    And I am on the 'Add a user' page
    And the 'role' in the summary is:
      | Service admin |
    And the legend is 'Select the service access for the user'
    And I select 'Legal Services'
    And I select 'Management Consultancy'
    Then I click on 'Continue'
    And I am on the 'Add a user' page
    And the 'role' in the summary is:
      | Service admin |
    And the 'service access' in the summary is:
      | Legal Services          |
      | Management Consultancy  |
    And I do not have an existing user in cognito with email 'name@example.com'
    And I enter the following details into the form:
      | Email address           | name@example.com    |
      | Mobile telephone number | 07123456789         |
    Then I click on 'Continue'
    And I am on the 'Add a user' page
    And the 'role' in the summary is:
      | Service admin |
    And the 'service access' in the summary is:
      | Legal Services          |
      | Management Consultancy  |
    And the 'email' in the summary is:
      | name@example.com  |
    And the 'telephone number' in the summary is:
      | 07123456789 |
    And I am able to create a user account with:
      | role              | Service admin                         |
      | service access    | Legal Services,Management Consultancy |
      | email             | name@example.com                      |
      | telephone number  | +447123456789                         |
    Then I click on 'Create user account'
    And I am on the 'Crown Marketplace dashboard' page
    And the account 'name@example.com' has been added

  Scenario: Create a User Support user
    Given I choose the 'User support' radio button
    Then I click on 'Continue'
    And I am on the 'Add a user' page
    And the 'role' in the summary is:
      | User support  |
    And I do not have an existing user in cognito with email 'name@example.com'
    And I enter the following details into the form:
      | Email address           | name@example.com    |
      | Mobile telephone number | 07123456789         |
    Then I click on 'Continue'
    And I am on the 'Add a user' page
    And the 'role' in the summary is:
      | User support  |
    And the 'email' in the summary is:
      | name@example.com  |
    And the 'telephone number' in the summary is:
      | 07123456789 |
    And I am able to create a user account with:
      | role              | User support      |
      | email             | name@example.com  |
      | telephone number  | +447123456789     |
    Then I click on 'Create user account'
    And I am on the 'Crown Marketplace dashboard' page
    And the account 'name@example.com' has been added

  Scenario: Change the role
    Given I choose the 'Buyer' radio button
    Then I click on 'Continue'
    And I am on the 'Add a user' page
    And the 'role' in the summary is:
      | Buyer |
    And the legend is 'Select the service access for the user'
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
    And I change the 'role' from the user summary
    Then I am on the 'Add a user' page
    And the legend is 'Select the role for the user'
    Given I choose the 'User support' radio button
    Then I click on 'Continue'
    And I am on the 'Add a user' page
    And the 'role' in the summary is:
      | User support |
    And I enter the following details into the form:
      | Mobile telephone number | 07123456789         |
    Then I click on 'Continue'
    And I am on the 'Add a user' page
    And the 'role' in the summary is:
      | User support |
    And the 'email' in the summary is:
      | name@example.com  |
    And the 'telephone number' in the summary is:
      | 07123456789 |
    And I change the 'role' from the user summary
    Then I am on the 'Add a user' page
    And the legend is 'Select the role for the user'
    Given I choose the 'Service admin' radio button
    Then I click on 'Continue'
    And I am on the 'Add a user' page
    And the legend is 'Select the service access for the user'
    And the 'role' in the summary is:
      | Service admin |
    Then I click on 'Continue'    
    And the 'role' in the summary is:
      | Service admin |
    And the 'service access' in the summary is:
      | Facilities Management |

  Scenario: Change the service access
    Given I choose the 'Service admin' radio button
    Then I click on 'Continue'
    And I am on the 'Add a user' page
    And the 'role' in the summary is:
      | Service admin |
    And the legend is 'Select the service access for the user'
    And I select 'Legal Services'
    And I select 'Management Consultancy'
    Then I click on 'Continue'
    And I am on the 'Add a user' page
    And the 'role' in the summary is:
      | Service admin |
    And the 'service access' in the summary is:
      | Legal Services          |
      | Management Consultancy  |
    And I do not have an existing user in cognito with email 'name@example.com'
    And I enter the following details into the form:
      | Email address           | name@example.com    |
      | Mobile telephone number | 07123456789         |
    Then I click on 'Continue'
    And I am on the 'Add a user' page
    And the 'role' in the summary is:
      | Service admin |
    And the 'service access' in the summary is:
      | Legal Services          |
      | Management Consultancy  |
    And the 'email' in the summary is:
      | name@example.com  |
    And the 'telephone number' in the summary is:
      | 07123456789 |
    And I change the 'service access' from the user summary
    Then I am on the 'Add a user' page
    And the legend is 'Select the service access for the user'
    Then I click on 'Continue'
    And the 'role' in the summary is:
      | Service admin |
    Then I click on 'Continue'
    And I am on the 'Add a user' page
    And the 'role' in the summary is:
      | Service admin |
    And the 'service access' in the summary is:
      | Legal Services          |
      | Management Consultancy  |
    And I change the 'service access' from the user summary
    And I select 'Supply Teachers'
    Then I click on 'Continue'
    And I am on the 'Add a user' page
    And the 'role' in the summary is:
      | Service admin |
    And the 'service access' in the summary is:
      | Legal Services          |
      | Management Consultancy  |
      | Supply Teachers         |

  Scenario: Change the user detail access
    Given I choose the 'User support' radio button
    Then I click on 'Continue'
    And I am on the 'Add a user' page
    And the 'role' in the summary is:
      | User support  |
    And I do not have an existing user in cognito with email 'name@example.com'
    And I enter the following details into the form:
      | Email address           | name@example.com    |
      | Mobile telephone number | 07123456789         |
    Then I click on 'Continue'
    And I am on the 'Add a user' page
    And the 'role' in the summary is:
      | User support  |
    And the 'email' in the summary is:
      | name@example.com  |
    And the 'telephone number' in the summary is:
      | 07123456789 |
    And I change the 'email' from the user summary
    And I am on the 'Add a user' page
    And the 'role' in the summary is:
      | User support  |
    And I enter the following details into the form:
      | Email address | name@test.com |
    And I do not have an existing user in cognito with email 'name@test.com'
    Then I click on 'Continue'
    And I am on the 'Add a user' page
    And the 'role' in the summary is:
      | User support  |
    And the 'email' in the summary is:
      | name@test.com |
    And the 'telephone number' in the summary is:
      | 07123456789 |
    And I change the 'telephone number' from the user summary
    And the 'role' in the summary is:
      | User support  |
    And I enter the following details into the form:
      | Mobile telephone number | 07987654321 |
    Then I click on 'Continue'
    And I am on the 'Add a user' page
    And the 'role' in the summary is:
      | User support  |
    And the 'email' in the summary is:
      | name@test.com |
    And the 'telephone number' in the summary is:
      | 07987654321 |
