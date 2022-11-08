@allow_list @javascript @pipeline
Feature: Allow list - User admin - Search allow list

  Scenario: Serach allow list
    Given I sign in as an 'user admin' user go to the crown marketplace dashboard
    When I click on 'Allow list'
    Then I am on the 'Allow list' page
    And the following email domains are in the list:
      | email.com   |
      | example.com |
      | test.com    |
    And I enter 'te' into the email domain search
    And the following email domains are in the list:
      | test.com    |
    And I enter 'test.co.uk' into the email domain search
    And the following email domains are in the list:
      | No email domains found  |
    And I enter '' into the email domain search
    And the following email domains are in the list:
      | email.com   |
      | example.com |
      | test.com    |
    And I click on 'Home'
    Then I am on the 'Crown Marketplace dashboard' page
