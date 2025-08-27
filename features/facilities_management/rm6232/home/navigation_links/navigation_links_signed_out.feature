Feature: Navigation links when signed out

  Background: I navigate to the start page
    When I go to the facilities management RM6232 start page

  Scenario: Start page
    And I should see the following navigation links:
      | Create an account |
      | Sign in           |

  Scenario: Not permitted page
    And I go to the 'buyer' not permitted page for 'RM6232'
    And I should see the following navigation links:
      | Create an account |
      | Sign in           |

  Scenario: Sign in page 
    And I click on 'Start now'
    Then I am on the 'Sign in to your account' page
    And I should see the following navigation links:
      | Back to start     |
      | Create an account |
      | Sign in           |
    And I click on 'Back to start'
    And I am on the 'Find a facilities management supplier' page

  Scenario: Cookies policy
    When I click on 'Cookie policy'
    Then I am on the 'Details about cookies on Crown Marketplace' page
    And I should see the following navigation links:
      | Back to start     |
      | Create an account |
      | Sign in           |
    And I click on 'Back to start'
    And I am on the 'Find a facilities management supplier' page

  Scenario: Cookies settings
    When I click on 'Cookie settings'
    Then I am on the 'Cookies on Crown Marketplace' page
    And I should see the following navigation links:
      | Back to start     |
      | Create an account |
      | Sign in           |
    And I click on 'Back to start'
    And I am on the 'Find a facilities management supplier' page

  Scenario: Accessibility statement
    When I click on 'Accessibility statement'
    Then I am on the 'Facilities Management (FM) Accessibility statement' page
    And I should see the following navigation links:
      | Back to start     |
      | Create an account |
      | Sign in           |
    And I click on 'Back to start'
    And I am on the 'Find a facilities management supplier' page
