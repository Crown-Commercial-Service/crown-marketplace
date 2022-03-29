@accessibility @javascript
Feature: Contract summary accessibility

  Scenario Outline: Contract summary
    Given I sign in and navigate to my account for 'RM3830'
    And I have a contract that has been '<state>' called 'My contract'
    And I click on 'Continue a procurement'
    Then I navigate to the contract 'My contract' in '<location>'
    Then the page should be axe clean

    Examples:
      | state       | location    |
      | sent        | Sent offers |
      | accepted    | Sent offers |
      | declined    | Sent offers |
      | expired     | Sent offers |
      | not_signed  | Sent offers |
      | signed      | Contracts   |

  @contract_emails
  Scenario: Closed contract
    Given I sign in and navigate to my account for 'RM3830'
    And I have a contract that has been 'sent' called 'My contract'
    And I click on 'Continue a procurement'
    Then I navigate to the contract 'My contract' in 'Sent offers'
    Then I click on 'Close this procurement'
    And I am on the 'Are you sure you wish to close' page
    And I enter the reason for closing the contract:
      | The procurement is no longer required |
    Then I click on 'Close this procurement'
    Then I am on the 'Your procurement has been closed' page
    And I click on 'Return to procurements dashboard'
    Then I am on the 'Procurements dashboard' page
    Then I navigate to the contract 'My contract' in 'Closed'
    Then the page should be axe clean
