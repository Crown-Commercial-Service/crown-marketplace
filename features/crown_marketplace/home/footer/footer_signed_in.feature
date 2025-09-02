@allow_list
Feature: Crown Marketplace admin footer links - signed in

  Background: Crown Marketplace admin signs in
    Given I sign in as an 'super admin' user go to the crown marketplace dashboard

  Scenario: Cookies policy
    When I click on 'Cookie policy'
    Then I am on the 'Details about cookies on Crown Marketplace' page
    And I click on 'Crown Marketplace dashboard'
    Then I am on the 'Crown Marketplace dashboard' page

  Scenario: Cookies settings
    When I click on 'Cookie settings'
    Then I am on the 'Cookies on Crown Marketplace' page
    And I click on 'Crown Marketplace dashboard'
    Then I am on the 'Crown Marketplace dashboard' page

  Scenario: Accessibility statement
    When I click on 'Accessibility statement'
    Then I am on the 'Facilities Management (FM) Accessibility statement' page
    And I click on 'Crown Marketplace dashboard'
    Then I am on the 'Crown Marketplace dashboard' page
