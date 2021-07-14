Feature: Navigation links when signed in

  Background: Supplier signs in
    Given I sign in as a supplier and navigate to my account

  Scenario: Not permitted page - My dashboard
    And I go to the not permitted page
    And I should see the following navigation links:
      | My dashboard  |
      | Sign out      |
    And I click on 'My dashboard'
    And I am on the 'Direct award dashboard' page

  Scenario: Not permitted page - sign out
    And I go to the not permitted page
    And I should see the following navigation links:
      | My dashboard  |
      | Sign out      |
    And I click on 'Sign out'
    And I am on the 'Sign in to your account' page

  Scenario: Cookies policy - My dashboard
    When I click on 'Cookie policy'
    Then I am on the 'Details about cookies on Crown Marketplace' page
    And I should see the following navigation links:
      | My dashboard  |
      | Sign out      |
    And I click on 'My dashboard'
    And I am on the 'Direct award dashboard' page

  Scenario: Cookies policy - Sign out
    When I click on 'Cookie policy'
    Then I am on the 'Details about cookies on Crown Marketplace' page
    And I should see the following navigation links:
      | My dashboard  |
      | Sign out      |
    And I click on 'Sign out'
    And I am on the 'Sign in to your account' page

  Scenario: Cookies settings - My dashboard
    When I click on 'Cookie settings'
    Then I am on the 'Cookies on Crown Marketplace' page
    And I should see the following navigation links:
      | My dashboard  |
      | Sign out      |
    And I click on 'My dashboard'
    And I am on the 'Direct award dashboard' page

  Scenario: Cookies settings - Sign out
    When I click on 'Cookie settings'
    Then I am on the 'Cookies on Crown Marketplace' page
    And I should see the following navigation links:
      | My dashboard  |
      | Sign out      |
    And I click on 'Sign out'
    And I am on the 'Sign in to your account' page

  Scenario: Accessibility statement - My dashboard
    When I click on 'Accessibility statement'
    Then I am on the 'Facilities Management (FM) Accessibility statement' page
    And I should see the following navigation links:
      | My dashboard  |
      | Sign out      |
    And I click on 'My dashboard'
    And I am on the 'Direct award dashboard' page

  Scenario: Accessibility statement - Sign out
    When I click on 'Accessibility statement'
    Then I am on the 'Facilities Management (FM) Accessibility statement' page
    And I should see the following navigation links:
      | My dashboard  |
      | Sign out      |
    And I click on 'Sign out'
    And I am on the 'Sign in to your account' page

  Scenario: Supplier dashboard - Sign out
      And I should see the following navigation links:
      | Sign out      |
    And I click on 'Sign out'
    And I am on the 'Sign in to your account' page

