@allow_list
Feature: Manage users - User support - Add user - Validations

  Background: Navigate to add user page
    Given I sign in as an 'user support' user go to the crown marketplace dashboard
    When I click on 'Invite a new user'
    Then I am on the 'Add a user' page
    And the legend is 'Select the service access for the user'

  Scenario: Select the service access for the user - no service access selected
    Then I click on 'Continue'
    Then I should see the following error messages:
      | You must select the service access for the user from this list  |

  Scenario Outline: Email address - invalid
    And I select 'Facilities Management'
    Then I click on 'Continue'
    And I am on the 'Add a user' page
    And I have an existing user in cognito with email '<email>'
    And I enter the following details into the form:
      | Email address | <email> |
    Then I click on 'Continue'
    Then I should see the following error messages:
      | <error_message> |

    Examples:
      | email             | error_message                                                       |
      |                   | Enter an email address in the correct format, like name@example.com |
      | name@Example.com  | Email address cannot contain any capital letters                    |
      | name@example.com  | An account with this email already exists                           |

  Scenario: Email address - allow list
    And I select 'Facilities Management'
    Then I click on 'Continue'
    And I am on the 'Add a user' page
    And I do not have an existing user in cognito with email 'name@test.gov.uk'
    And I enter the following details into the form:
      | Email address | name@test.gov.uk |
    Then I click on 'Continue'
    Then I should see the following error messages:
      | Email domain is not in the allow list |

  Scenario: Create user - service error
    And I select 'Facilities Management'
    Then I click on 'Continue'
    And I am on the 'Add a user' page
    And I do not have an existing user in cognito with email 'name@example.com'
    And I enter the following details into the form:
      | Email address | name@example.com  |
    Then I click on 'Continue'
    And I am on the 'Add a user' page
    And the 'role' in the summary is:
      | Buyer |
    And the 'service access' in the summary is:
      | Facilities Management |
    And the 'email' in the summary is:
      | name@example.com  |
    And I cannot create a user account because of the 'service' error
    Then I click on 'Create user account'
    Then I should see the following error messages:
      | An error occured: service |
