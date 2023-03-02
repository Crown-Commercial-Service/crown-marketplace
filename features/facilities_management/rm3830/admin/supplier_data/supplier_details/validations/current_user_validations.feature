Feature: Current user - validations

  Background: Navigate to the current user section
    Given other user accounts exist
    Given I sign in as an admin and navigate to the 'RM3830' dashboard
    And I click on 'Supplier details'
    Then I am on the 'Supplier details' page
    And I click on 'Dare, Heaney and Kozey'
    Then I am on the 'Supplier details' page
    And I change the 'Current user' for the supplier details
    Then I am on the 'Supplier user account' page

  Scenario Outline: Contact user email validation
    Given I enter '<user_email>' into the 'User email' field
    And I click on 'Save and return'
    Then I should see the following error messages:
      | <error_message> |

    Examples:
      | user_email              | error_message                                                                       |
      |                         | Enter an email address in the correct format, for example name@organisation.gov.uk  |
      | fakeemail               | Enter an email address in the correct format, for example name@organisation.gov.uk  |
      | test@test.com           | The supplier must be registered with the facilities management service              |
      | buyer@test.com          | The user must have supplier access                                                  |
      | othersupplier@test.com  | The user cannot belong to another supplier                                          |
