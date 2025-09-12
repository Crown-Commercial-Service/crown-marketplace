Feature: Navigation links when signed in

  Background: Admin signs in
    Given I sign in as an admin and navigate to the 'RM6232' dashboard

  Scenario: Cookies policy - Admin dashboard
    When I click on 'Cookie policy'
    Then I am on the 'Details about cookies on Crown Marketplace' page
    And I should see the following navigation links:
      | Admin dashboard |
      | Sign out        |
    And I click on 'Admin dashboard'
    And I am on the 'RM6232 administration dashboard' page

  Scenario: Cookies policy - Sign out
    When I click on 'Cookie policy'
    Then I am on the 'Details about cookies on Crown Marketplace' page
    And I should see the following navigation links:
      | Admin dashboard |
      | Sign out        |
    And I click on 'Sign out'
    And I am on the 'Sign in to the RM6232 administration dashboard' page

  Scenario: Cookies settings - Admin dashboard
    When I click on 'Cookie settings'
    Then I am on the 'Cookies on Crown Marketplace' page
    And I should see the following navigation links:
      | Admin dashboard |
      | Sign out        |
    And I click on 'Admin dashboard'
    And I am on the 'RM6232 administration dashboard' page

  Scenario: Cookies settings - Sign out
    When I click on 'Cookie settings'
    Then I am on the 'Cookies on Crown Marketplace' page
    And I should see the following navigation links:
      | Admin dashboard |
      | Sign out        |
    And I click on 'Sign out'
    And I am on the 'Sign in to the RM6232 administration dashboard' page

  Scenario: Accessibility statement - Admin dashboard
    When I click on 'Accessibility statement'
    Then I am on the 'Facilities Management (FM) Accessibility statement' page
    And I should see the following navigation links:
      | Admin dashboard |
      | Sign out        |
    And I click on 'Admin dashboard'
    And I am on the 'RM6232 administration dashboard' page

  Scenario: Accessibility statement - Sign out
    When I click on 'Accessibility statement'
    Then I am on the 'Facilities Management (FM) Accessibility statement' page
    And I should see the following navigation links:
      | Admin dashboard |
      | Sign out        |
    And I click on 'Sign out'
    And I am on the 'Sign in to the RM6232 administration dashboard' page

  Scenario: Admin dashboard - Sign out
    And I should see the following navigation links:
      | Sign out |
    And I click on 'Sign out'
    And I am on the 'Sign in to the RM6232 administration dashboard' page

  Scenario: Accessibility statement - Admin dashboard
    When I click on 'Accessibility statement'
    Then I am on the 'Facilities Management (FM) Accessibility statement' page
    And I should see the following navigation links:
      | Admin dashboard |
      | Sign out        |
    And I click on 'Admin dashboard'
    And I am on the 'RM6232 administration dashboard' page

  Scenario: Accessibility statement - Sign out
    When I click on 'Accessibility statement'
    Then I am on the 'Facilities Management (FM) Accessibility statement' page
    And I should see the following navigation links:
      | Admin dashboard |
      | Sign out        |
    And I click on 'Sign out'
    And I am on the 'Sign in to the RM6232 administration dashboard' page

  Scenario: Admin page - Admin dashboard
    When I click on 'Supplier data'
    Then I am on the 'Supplier data' page
    And I should see the following navigation links:
      | Admin dashboard |
      | Sign out        |
    And I click on 'Admin dashboard'
    And I am on the 'RM6232 administration dashboard' page

  Scenario: Admin page - Accessibility statement - Sign out
    When I click on 'Supplier data'
    Then I am on the 'Supplier data' page
    And I should see the following navigation links:
      | Admin dashboard |
      | Sign out        |
    And I click on 'Sign out'
    And I am on the 'Sign in to the RM6232 administration dashboard' page
