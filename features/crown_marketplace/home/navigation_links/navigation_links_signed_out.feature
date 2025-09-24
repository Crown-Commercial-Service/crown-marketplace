Feature: Navigation links when signed out

  Background: Crown Marketplace admin on sign in page
    Given I go to the crown marketplace start page

  Scenario: Sign in page
    And I should see the following navigation links:
      | Sign in |

  Scenario: Not permitted page
    And I go to the crown marketplace not permitted page
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
    And I am on the 'Sign in to manage Crown Marketplace' page

  Scenario: Cookies settings
    When I click on 'Cookie settings'
    Then I am on the 'Cookies on Crown Marketplace' page
    And I should see the following navigation links:
      | Back to start |
      | Sign in       |
    And I click on 'Back to start'
    And I am on the 'Sign in to manage Crown Marketplace' page

  Scenario: Accessibility statement
    When I click on 'Accessibility statement'
    Then I am on the 'Facilities Management (FM) Accessibility statement' page
    And I should see the following navigation links:
      | Back to start |
      | Sign in       |
    And I click on 'Back to start'
    And I am on the 'Sign in to manage Crown Marketplace' page
