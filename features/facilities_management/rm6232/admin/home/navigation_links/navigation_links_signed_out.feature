Feature: Navigation links when signed out

  Background: Admin on sign in page
    Given I go to the facilities management 'RM6232' admin start page

  Scenario: Sign in page
    And I should see the following navigation links:
      | Sign in |

  Scenario: Not permitted page
    And I go to the 'admin' not permitted page for 'RM6232'
    And I should see the following navigation links:
      | Back to start |
      | Sign in       |

  Scenario: Cookies policy
    When I click on 'Cookie policy'
    Then I am on the 'Details about cookies on Crown Marketplace' page
    And I should see the following navigation links:
      | Back to start |
      | Sign in       |
    And I click on 'Back to start'
    And I am on the 'Sign in to the RM6232 administration dashboard' page

  Scenario: Cookies settings
    When I click on 'Cookie settings'
    Then I am on the 'Cookies on Crown Marketplace' page
    And I should see the following navigation links:
      | Back to start |
      | Sign in       |
    And I click on 'Back to start'
    And I am on the 'Sign in to the RM6232 administration dashboard' page

  Scenario: Accessibility statement
    When I click on 'Accessibility statement'
    Then I am on the 'Facilities Management (FM) Accessibility statement' page
    And I should see the following navigation links:
      | Back to start |
      | Sign in       |
    And I click on 'Back to start'
    And I am on the 'Sign in to the RM6232 administration dashboard' page
