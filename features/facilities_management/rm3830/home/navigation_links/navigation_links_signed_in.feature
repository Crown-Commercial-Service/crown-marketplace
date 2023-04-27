Feature: Navigation links when signed in

  Background: I navigate to my account page
    Given I sign in and navigate to my account for 'RM3830'

  Scenario: Start page
    When I go to the facilities management RM3830 start page
    And I should see the following navigation links:
      | Sign out |

  Scenario: Not permitted page - My accout
    And I go to the 'buyer' not permitted page for 'RM3830'
    And I should see the following navigation links:
      | My account  |
      | Sign out    |
    And I click on 'My account'
    And I am on the 'Your account' page

  Scenario: Not permitted page - sign out
    And I go to the 'buyer' not permitted page for 'RM3830'
    And I should see the following navigation links:
      | My account  |
      | Sign out    |
    And I click on 'Sign out'
    And I am on the 'Sign in to your account' page

  Scenario: Cookies policy - My accout
    When I click on 'Cookie policy'
    Then I am on the 'Details about cookies on Crown Marketplace' page
    And I should see the following navigation links:
      | My account  |
      | Sign out    |
    And I click on 'My account'
    And I am on the 'Your account' page

  Scenario: Cookies policy - Sign out
    When I click on 'Cookie policy'
    Then I am on the 'Details about cookies on Crown Marketplace' page
    And I should see the following navigation links:
      | My account  |
      | Sign out    |
    And I click on 'Sign out'
    And I am on the 'Sign in to your account' page

  Scenario: Cookies settings - My accout
    When I click on 'Cookie settings'
    Then I am on the 'Cookies on Crown Marketplace' page
    And I should see the following navigation links:
      | My account  |
      | Sign out    |
    And I click on 'My account'
    And I am on the 'Your account' page

  Scenario: Cookies settings - Sign out
    When I click on 'Cookie settings'
    Then I am on the 'Cookies on Crown Marketplace' page
    And I should see the following navigation links:
      | My account  |
      | Sign out    |
    And I click on 'Sign out'
    And I am on the 'Sign in to your account' page

  Scenario: Accessibility statement - My accout
    When I click on 'Accessibility statement'
    Then I am on the 'Facilities Management (FM) Accessibility statement' page
    And I should see the following navigation links:
      | My account  |
      | Sign out    |
    And I click on 'My account'
    And I am on the 'Your account' page

  Scenario: Accessibility statement - Sign out
    When I click on 'Accessibility statement'
    Then I am on the 'Facilities Management (FM) Accessibility statement' page
    And I should see the following navigation links:
      | My account  |
      | Sign out    |
    And I click on 'Sign out'
    And I am on the 'Sign in to your account' page

  Scenario: Home page - Sign out
    And I should see the following navigation links:
      | Sign out      |
    And I click on 'Sign out'
    And I am on the 'Sign in to your account' page

  Scenario: Procurement dashboard - My account
    Then I click on 'Continue a procurement'
    Then I am on the 'Procurements dashboard' page
    And I should see the following navigation links:
      | My account  |
      | Sign out    |
    And I click on 'My account'
    And I am on the 'Your account' page

  Scenario: Procurement dashboard - Sign out
    Then I click on 'Continue a procurement'
    Then I am on the 'Procurements dashboard' page
    And I should see the following navigation links:
      | My account  |
      | Sign out    |
    And I click on 'Sign out'
    And I am on the 'Sign in to your account' page

  Scenario: Buyer details - My account
    Then I click on 'Manage my details'
    Then I am on the 'Manage your details' page
    And I should see the following navigation links:
      | My account  |
      | Sign out    |
    And I click on 'My account'
    And I am on the 'Your account' page

  Scenario: Buyer details - Sign out
    Then I click on 'Manage my details'
    Then I am on the 'Manage your details' page
    And I should see the following navigation links:
      | My account  |
      | Sign out    |
    And I click on 'Sign out'
    And I am on the 'Sign in to your account' page

  Scenario: Buyer details - Add address - My account
    Then I click on 'Manage my details'
    Then I am on the 'Manage your details' page
    And I click on 'Enter address manually, if you can’t find address'
    Then I am on the 'Add address' page
    And I should see the following navigation links:
      | My account  |
      | Sign out    |
    And I click on 'My account'
    And I am on the 'Your account' page

  Scenario: Buyer details - Add address - Sign out
    Then I click on 'Manage my details'
    Then I am on the 'Manage your details' page
    And I click on 'Enter address manually, if you can’t find address'
    Then I am on the 'Add address' page
    And I should see the following navigation links:
      | My account  |
      | Sign out    |
    And I click on 'Sign out'
    And I am on the 'Sign in to your account' page