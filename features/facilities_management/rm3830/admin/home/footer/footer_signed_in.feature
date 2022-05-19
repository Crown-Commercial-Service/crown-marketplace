Feature: Admin footer links - signed in

  Background: Admin signs in
    Given I sign in as an admin and navigate to the 'RM3830' dashboard

  Scenario: Cookies policy
    When I click on 'Cookie policy'
    Then I am on the 'Details about cookies on Crown Marketplace' page
    And I click on 'Admin dashboard'
    Then I am on the 'RM3830 administration dashboard' page

  Scenario: Cookies settings
    When I click on 'Cookie settings'
    Then I am on the 'Cookies on Crown Marketplace' page
    And I click on 'Admin dashboard'
    Then I am on the 'RM3830 administration dashboard' page

  Scenario: Accessibility statement
    When I click on 'Accessibility statement'
    Then I am on the 'Facilities Management (FM) Accessibility statement' page
    And I click on 'Admin dashboard'
    Then I am on the 'RM3830 administration dashboard' page
