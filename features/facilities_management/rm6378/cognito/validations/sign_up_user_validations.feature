@allow_list
Feature: Sign up user - RM6378 - Validations

  Background: navigate to create an account page
    Given I go to the facilities management RM6378 start page
    And I am on the 'Find a facilities management supplier' page
    When I click on 'Start now'
    Then I am on the 'Sign in to your account' page
    And I click on 'Create a CCS account'
    Then I am on the 'Create a CCS account' page

  Scenario: Email validations
    Given I enter '<email>' for my email
    And I enter 'Passowrd1!' for the password
    And I enter 'Passowrd1!' for the password confirmation
    When I click on 'Create account'
    Then I should see the following error messages:
      | <error_message> |

    Examples:
      | email         | error_message                                                       |
      |               | Enter an email address in the correct format, like name@example.com |
      | Test@test.com | Email address cannot contain any capital letters                    |

  Scenario: Not on allow list
    Given I enter 'test@tmail.com' for my email
    And I enter 'Passowrd1!' for the password
    And I enter 'Passowrd1!' for the password confirmation
    When I click on 'Create account'
    Then I am on the 'You must use a public sector email address' page

  Scenario Outline: Password validations
    Given I enter 'test@test.com' for my email
    And I enter '<password>' for the password
    And I enter '<password>' for the password confirmation
    When I click on 'Create account'
    Then I should see the following error messages:
      | <error_message> |

    Examples:
      | password   | error_message                             |
      | Pass!1     | Password must be 8 characters or more     |
      | password1! | Password must include a capital letter    |
      | Password1  | Password must include a special character |
      | Password!  | Password must include a number            |

  Scenario: Password blank
    Given I enter 'test@test.com' for my email
    And I enter '' for the password
    And I enter '' for the password confirmation
    When I click on 'Create account'
    Then I should see the following error messages:
      | Enter a password    |
      | Enter your password |

  Scenario: Password confirmation doesn't match
    Given I enter 'test@test.com' for my email
    And I enter 'Password1!' for the password
    And I enter 'ValidPassw0rd!' for the password confirmation
    When I click on 'Create account'
    Then I should see the following error messages:
      | Passwords don't match |

  Scenario: Create an account - username exists error
    And I cannot create an account becaue of the 'username exists' error
    Then I am on the 'Activate your account' page

  Scenario: Create an account - service error
    And I cannot create an account becaue of the 'service' error
    Then I should see the following error messages:
      | An error occured: service |
