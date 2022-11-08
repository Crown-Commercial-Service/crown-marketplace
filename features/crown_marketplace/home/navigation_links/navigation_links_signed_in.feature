@allow_list
Feature: Navigation links when signed in

  Background: Crown Marketplace admin signs in
    Given I sign in as an 'super admin' user go to the crown marketplace dashboard

  Scenario: Cookies policy - Crown Marketplace dashboard
    When I click on 'Cookie policy'
    Then I am on the 'Details about cookies on Crown Marketplace' page
    And I should see the following navigation links:
      | Crown Marketplace dashboard |
      | Sign out                    |
    And I click on 'Crown Marketplace dashboard'
    Then I am on the 'Crown Marketplace dashboard' page
    
  Scenario: Cookies policy - Sign out
    When I click on 'Cookie policy'
    Then I am on the 'Details about cookies on Crown Marketplace' page
    And I should see the following navigation links:
      | Crown Marketplace dashboard |
      | Sign out                    |
    And I click on 'Sign out'
    And I am on the 'Sign in to manage Crown Marketplace' page

  Scenario: Cookies settings - Crown Marketplace dashboard
    When I click on 'Cookie settings'
    Then I am on the 'Cookies on Crown Marketplace' page
    And I should see the following navigation links:
      | Crown Marketplace dashboard |
      | Sign out                    |
    And I click on 'Crown Marketplace dashboard'
    Then I am on the 'Crown Marketplace dashboard' page

  Scenario: Cookies settings - Sign out
    When I click on 'Cookie settings'
    Then I am on the 'Cookies on Crown Marketplace' page
    And I should see the following navigation links:
      | Crown Marketplace dashboard |
      | Sign out                    |
    And I click on 'Sign out'
    And I am on the 'Sign in to manage Crown Marketplace' page

  Scenario: Accessibility statement - Crown Marketplace dashboard
    When I click on 'Accessibility statement'
    Then I am on the 'Facilities Management (FM) Accessibility statement' page
    And I should see the following navigation links:
      | Crown Marketplace dashboard |
      | Sign out                    |
    And I click on 'Crown Marketplace dashboard'
    Then I am on the 'Crown Marketplace dashboard' page

  Scenario: Accessibility statement - Sign out
    When I click on 'Accessibility statement'
    Then I am on the 'Facilities Management (FM) Accessibility statement' page
    And I should see the following navigation links:
      | Crown Marketplace dashboard |
      | Sign out                    |
    And I click on 'Sign out'
    And I am on the 'Sign in to manage Crown Marketplace' page

   Scenario: Crown Marketplace dashboard - Sign out
     And I should see the following navigation links:
       | Sign out                    |
     And I click on 'Sign out'
     And I am on the 'Sign in to manage Crown Marketplace' page

  Scenario: Accessibility statement - Crown Marketplace dashboard
    When I click on 'Accessibility statement'
    Then I am on the 'Facilities Management (FM) Accessibility statement' page
    And I should see the following navigation links:
      | Crown Marketplace dashboard |
      | Sign out                    |
    And I click on 'Crown Marketplace dashboard'
    Then I am on the 'Crown Marketplace dashboard' page
 

  Scenario: Accessibility statement - Sign out
    When I click on 'Accessibility statement'
    Then I am on the 'Facilities Management (FM) Accessibility statement' page
    And I should see the following navigation links:
      | Crown Marketplace dashboard |
      | Sign out                    |
    And I click on 'Sign out'
    And I am on the 'Sign in to manage Crown Marketplace' page

  @allow_list
  Scenario: Crown Marketplace admin page - Crown Marketplace dashboard
     When I click on 'Allow list'
     Then I am on the 'Allow list' page
    And I should see the following navigation links:
      | Crown Marketplace dashboard |
      | Sign out                    |
    And I click on 'Crown Marketplace dashboard'
    Then I am on the 'Crown Marketplace dashboard' page

  @allow_list
  Scenario: Crown Marketplace admin page - Accessibility statement - Sign out
     When I click on 'Allow list'
     Then I am on the 'Allow list' page
    And I should see the following navigation links:
      | Crown Marketplace dashboard |
      | Sign out                    |
    And I click on 'Sign out'
    And I am on the 'Sign in to manage Crown Marketplace' page
