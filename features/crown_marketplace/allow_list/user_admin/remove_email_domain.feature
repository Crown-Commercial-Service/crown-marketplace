@allow_list
Feature: Allow list - User admin - Remove email domain

  Background: Sign in and navigate to the allow list page
    Given I sign in as an 'user admin' user go to the crown marketplace dashboard
    When I click on 'Allow list'
    Then I am on the 'Allow list' page
    And the following email domains are in the list:
      | email.com   |
      | example.com |
      | test.com    |
    And I click on remove for 'example.com'
    Then I am on the "Are you sure you want to remove 'example.com' from the Allow list?" page

  Scenario: Remove email domain
    And I click on 'Remove'
    Then I am on the 'Allow list' page
    And the email domian 'example.com' has been succesffuly removed
    And the following email domains are in the list:
      | email.com     |
      | test.com      |

  Scenario: Return links work
    Given I click on '<text>'
    Then I am on the 'Allow list' page

    Examples:
      | text                      |
      | Return to the allow list  |
      | Allow list                |
