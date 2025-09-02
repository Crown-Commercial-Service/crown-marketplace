@allow_list
Feature: Allow list - User admin - Add email domain

  Background: Sign in and navigate to the allow list page
    Given I sign in as an 'user admin' user go to the crown marketplace dashboard
    When I click on 'Allow list'
    Then I am on the 'Allow list' page
    And the following email domains are in the list:
      | email.com   |
      | example.com |
      | test.com    |
    And I click on 'Add a new email domain'
    Then I am on the 'Add an email domain' page

  Scenario: Add email domain
    And I enter 'new.emai.com' for the email domain
    And I click on 'Save and continue'
    Then I am on the 'Allow list' page
    And the email domian 'new.emai.com' has been succesffuly added
    And the following email domains are in the list:
      | email.com    |
      | example.com  |
      | new.emai.com |
      | test.com     |

  Scenario: Return links work
    Given I click on '<text>'
    Then I am on the 'Allow list' page

    Examples:
      | text                     |
      | Return to the allow list |
      | Allow list               |
