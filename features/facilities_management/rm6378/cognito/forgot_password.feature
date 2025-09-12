Feature: Forgot my password - RM6378

  Scenario: I forgot my password
    When I go to the facilities management RM6378 start page
    And I am on the 'Find a facilities management supplier' page
    When I click on 'Start now'
    And I am on the 'Sign in to your account' page
    When I click on 'I’ve forgotten my password'
    Then I am on the 'Reset password' page
    And I can reset my password with the roles:
      | fm_access |
      | buyer     |
    Then I am on the 'Reset your password' page
    And I enter the following details into the form:
      | New password         | ValidPassword1! |
      | Confirm new password | ValidPassword1! |
      | Verification code    | 123456          |
    And I click on 'Reset password'
    Then I am on the 'You have successfully changed your password' page
    And I click on the Sign in link
    And I am on the 'Sign in to your account' page
