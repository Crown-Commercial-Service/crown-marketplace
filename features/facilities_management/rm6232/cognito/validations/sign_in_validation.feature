Feature: Sign in to my account - RM6232 - Validations

  Background: Navigate to the sign in page
    When I go to the facilities management RM6232 start page
    And I am on the 'Find a facilities management supplier' page
    When I click on 'Start now'
    And I am on the 'Sign in to your account' page

  Scenario: I sign in to my account - missing parameters
    And I click on 'Sign in'
    Then I should see the following error messages:
      | You must provide your email address in the correct format, like name@example.com  |
      | You must provide your password                                                    |

  Scenario: I sign in to my account - cookies disabled
    And my cookies are disabled
    And I enter the following details into the form:
      | Email     | test@email.com  |
      | Password  | ValidPassword1! |
    And I click on 'Sign in'
    Then I should see the following error messages:
      | Your browser must have cookies enabled  |

  Scenario Outline: I sign in to my account - cognito error
    And I cannot sign in becaue of the '<error>' error
    Then I should see the following error messages:
      | <error_message> |
    
    Examples:
      | error           | error_message                                   |
      | user not found  | You must provide a correct username or password |
      | service         | You must provide a correct username or password |

  Scenario Outline: I sign in with MFA - invalid code
    Then I should sign in with MFA and with the roles:
      | fm_access |
      | buyer     |
    Then I am on the 'Enter your access code' page
    And I enter the following details into the form:
      | Access code | <value> |
    And I click on 'Continue'
    Then I should see the following error messages:
      | <error_message> |

    Examples:
      | value   | error_message                                     |
      |         | Enter the access code                             |
      | 123     | Access code must be 6 characters                  |
      | 1234567 | Access code must be 6 characters                  |
      | onetwo  | Access code must contain numeric characters only  |

  Scenario: I sign in with MFA - service error
    And I cannot sign in with MFA because of the 'service' error and I have the following roles:
      | fm_access |
      | buyer     |
    Then I am on the 'Enter your access code' page
    And I enter the following details into the form:
      | Access code | 123456  |
    And I click on 'Continue'
    Then I should see the following error messages:
      | An error occured: service |

  Scenario Outline:  I sign in for the first time - password errors
    Then I should sign in for the first time with the roles:
      | fm_access |
      | buyer     |
    And I am on the 'Change your password' page
    And I enter '<password>' for the password
    And I enter '<password>' for the password confirmation
    And I click on 'Change password and sign in'
    Then I should see the following error messages:
      | <error_message> |

    Examples:
      | password    | error_message                             |
      | Pass!1      | Password must be 8 characters or more     |
      | password1!  | Password must include a capital letter    |
      | Password1   | Password must include a special character |
      | Password!   | Password must include a number            |

  Scenario: I sign in for the first time - passwords blank
    Then I should sign in for the first time with the roles:
      | fm_access |
      | buyer     |
    And I am on the 'Change your password' page
    And I enter '' for the password
    And I enter '' for the password confirmation
    And I click on 'Change password and sign in'
    Then I should see the following error messages:
      | Enter a password    |
      | Enter your password |

  Scenario: I sign in for the first time - passwords don't match
    Then I should sign in for the first time with the roles:
      | fm_access |
      | buyer     |
    And I am on the 'Change your password' page
    And I enter 'Password1!' for the password
    And I enter 'ValidPassw0rd!' for the password confirmation
    And I click on 'Change password and sign in'
    Then I should see the following error messages:
      | Passwords don't match |

  Scenario: I sign in for the first time - service error
    And I cannot sign in for the first time because of the 'service' error and I have the following roles:
      | fm_access |
      | buyer     |
    And I am on the 'Change your password' page
    And I enter 'ValidPassword1!' for the password
    And I enter 'ValidPassword1!' for the password confirmation
    And I click on 'Change password and sign in'
    Then I should see the following error messages:
      | An error occured: service |

  Scenario Outline: I sign in for the first time with MFA - invalid code
    Then I should sign in for the first time with MFA Enabled and with the roles:
      | fm_access |
      | buyer     |
    And I am on the 'Change your password' page
    And I enter the following details into the form:
      | Create a password you'll remember | ValidPassword1! |
      | Confirm your password             | ValidPassword1! |
    And I click on 'Change password and sign in'
    Then I am on the 'Enter your access code' page
    And I enter the following details into the form:
      | Access code | <value> |
    And I click on 'Continue'
    Then I should see the following error messages:
      | <error_message> |

    Examples:
      | value   | error_message                                     |
      |         | Enter the access code                             |
      | 123     | Access code must be 6 characters                  |
      | 1234567 | Access code must be 6 characters                  |
      | onetwo  | Access code must contain numeric characters only  |

  Scenario: I sign in for the first time - service error
    And I cannot sign in for the first time with MFA Enabled because of the 'service' error and I have the following roles:
      | fm_access |
      | buyer     |
    And I am on the 'Change your password' page
    And I enter 'ValidPassword1!' for the password
    And I enter 'ValidPassword1!' for the password confirmation
    And I click on 'Change password and sign in'
    Then I am on the 'Enter your access code' page
    And I enter the following details into the form:
      | Access code | 123456  |
    And I click on 'Continue'
    Then I should see the following error messages:
      | An error occured: service |

  Scenario Outline: I sign in for the first time after creating an account - invalid code
    Then I should sign in as user who just created their account and with the roles:
      | fm_access |
      | buyer     |
    Then I am on the 'Activate your account' page
    And I enter the following details into the form:
      | Confirmation code | <value> |
    And I click on 'Continue'
    Then I should see the following error messages:
      | <error_message> |

    Examples:
      | value   | error_message                                           |
      |         | Enter your verification code                            |
      | 123     | Confirmation code must be 6 characters                  |
      | 1234567 | Confirmation code must be 6 characters                  |
      | onetwo  | Confirmation code must contain numeric characters only  |

  Scenario Outline: I sign in for the first time after creating an account - cognito error
    And I cannot sign in having just created my account because of the '<error>' error and I have the following roles:
      | fm_access |
      | buyer     |
    Then I am on the 'Activate your account' page
    And I enter the following details into the form:
      | Confirmation code | 123456 |
    And I click on 'Continue'
    Then I should see the following error messages:
      | <error_message> |

    Examples:
      | error           | error_message                                         |
      | not authorized  | Invalid verification code provided, please try again  |
      | service         | An error occured: service                             |

  Scenario Outline: I sign in and need to reset my password - password error
    Then I should sign in as a user who needs to reset their password and with the roles:
      | fm_access |
      | buyer     |
    Then I am on the 'Reset your password' page
    And I enter the following details into the form:
      | New password          | <password>  |
      | Confirm new password  | <password>  |
      | Verification code     | 123456      |
    And I click on 'Reset password'
    Then I should see the following error messages:
      | <error_message> |

    Examples:
      | password    | error_message                             |
      | Pass!1      | Password must be 8 characters or more     |
      | password1!  | Password must include a capital letter    |
      | Password1   | Password must include a special character |
      | Password!   | Password must include a number            |

  Scenario: I sign in and need to reset my password - passwords blank
    Then I should sign in as a user who needs to reset their password and with the roles:
      | fm_access |
      | buyer     |
    Then I am on the 'Reset your password' page
    And I enter the following details into the form:
      | New password          |         |
      | Confirm new password  |         |
      | Verification code     | 123456  |
    And I click on 'Reset password'
    Then I should see the following error messages:
      | Enter a password    |
      | Enter your password |

  Scenario: I sign in and need to reset my password - passwords don't match
    Then I should sign in as a user who needs to reset their password and with the roles:
      | fm_access |
      | buyer     |
    Then I am on the 'Reset your password' page
    And I enter the following details into the form:
      | New password          | Password1!      |
      | Confirm new password  | ValidPassw0rd!  |
      | Verification code     | 123456          |
    And I click on 'Reset password'
    Then I should see the following error messages:
      | Passwords don't match |

  Scenario: I sign in and need to reset my password - code blank
    Then I should sign in as a user who needs to reset their password and with the roles:
      | fm_access |
      | buyer     |
    Then I am on the 'Reset your password' page
    And I enter the following details into the form:
      | New password          | ValidPassword1! |
      | Confirm new password  | ValidPassword1! |
      | Verification code     |                 |
    And I click on 'Reset password'
    Then I should see the following error messages:
      | Enter your verification code  |

  Scenario Outline: I sign in and need to reset my password - cognito error
    And I cannot sign in and reset my password because of the '<error>' error and I have the following roles:
      | fm_access |
      | buyer     |
    Then I am on the 'Reset your password' page
    And I enter the following details into the form:
      | New password          | ValidPassword1! |
      | Confirm new password  | ValidPassword1! |
      | Verification code     | 123456          |
    And I click on 'Reset password'
    Then I should see the following error messages:
      | <error_message> |

    Examples:
      | error         | error_message                     |
      | code mismatch |  An error occured: code mismatch  |
      | service       | An error occured: service         |
