Feature: Current user

  Scenario: Changing the current user
    Given I sign in as an admin and navigate to the 'RM3830' dashboard
    And I click on 'Supplier details'
    Then I am on the 'Supplier details' page
    And I click on 'Abbott-Dooley'
    Then I am on the 'Supplier details' page
    And I change the 'Current user' for the supplier details
    Then I am on the 'Supplier user account' page
    Given I enter the user email into the user email field
    And I click on 'Save and return'
    Then I am on the 'Supplier details' page
    And the current user has the user email
