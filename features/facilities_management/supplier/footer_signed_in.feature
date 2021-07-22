Feature: Supplier footer links - signed in

  Background: Supplier signs in
    Given I sign in as a supplier and navigate to my account

  Scenario: Cookies policy
    When I click on 'Cookie policy'
    Then I am on the 'Details about cookies on Crown Marketplace' page
    And I click on 'Back to start'
    Then I am on the 'Direct award dashboard' page

  Scenario: Cookies settings
    When I click on 'Cookie settings'
    Then I am on the 'Cookies on Crown Marketplace' page
    And I click on 'Back to start'
    Then I am on the 'Direct award dashboard' page

  Scenario: Accessibility statement
    When I click on 'Accessibility statement'
    Then I am on the 'Facilities Management (FM) Accessibility statement' page
    And I click on 'Back to start'
    Then I am on the 'Direct award dashboard' page
