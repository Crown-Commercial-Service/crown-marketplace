Feature: Buyer footer links - signed in

  Background: Buyer signs in
    Given I sign in and navigate to my account for 'RM3830'

  Scenario: Cookies policy
    When I click on 'Cookie policy'
    Then I am on the 'Details about cookies on Crown Marketplace' page
    And I click on 'My account'
    Then I am on the 'Your account' page

  Scenario: Cookies settings
    When I click on 'Cookie settings'
    Then I am on the 'Cookies on Crown Marketplace' page
    And I click on 'My account'
    Then I am on the 'Your account' page

  Scenario: Accessibility statement
    When I click on 'Accessibility statement'
    Then I am on the 'Facilities Management (FM) Accessibility statement' page
    And I click on 'My account'
    Then I am on the 'Your account' page
