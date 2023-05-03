@mobile @javascript
Feature: Headers are responsive

  Scenario: Signed in and the navigation links are responsive
    Given I sign in and navigate to my account for 'RM3830'
    And I click on 'Manage my details'
    Then I am on the 'Manage your details' page
    And the header navigation links 'are not' visible
    Then I click on 'Menu'
    And the header navigation links 'are' visible
    Then I click on 'My account'
    And I am on the 'Your account' page
