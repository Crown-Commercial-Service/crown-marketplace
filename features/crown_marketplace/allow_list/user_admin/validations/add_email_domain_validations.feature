@allow_list @pipeline
Feature: Allow list - User admin - Add email domain - Validations

  Scenario Outline: Add email domain
    Given I sign in as an 'user admin' user go to the crown marketplace dashboard
    # When I click on 'Allow list'
    # Then I am on the 'Allow list' page
    And I click on 'Add a new email domain'
    Then I am on the 'Add an email domain' page
    And I enter '<email_domain>' for the email domain
    And I click on 'Save and continue'
    Then I should see the following error messages:
      | <error_message> |

    Examples:
      | email_domain    | error_message                                                             |
      |                 | Enter an email domain                                                     |
      | !nvalid.d()ma!n | The email domain can only contain letters, numbers, hyphens or full stops |
      | test.com        | The email domain is already in the Allow list                             |
