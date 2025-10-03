@allow_list
Feature: Sign up to facilties management - RM6378

  Scenario: I sign in to my existing account
    When I go to the facilities management RM6378 start page
    And I am on the 'Find a facilities management supplier' page
    When I click on 'Start now'
    And I am on the 'Sign in to your account' page
    And I click on 'Create a CCS account'
    Then I am on the 'Create a CCS account' page
    And I am able to create an 'fm' account
    Then I am on the 'Activate your account' page
    And I enter the following details into the form:
      | Confirmation code | 123456 |
    And I click on 'Continue'
    Then I am on the 'Your details' page
