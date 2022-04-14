@accessibility @javascript @contract_emails
Feature: Supplier contracts accessibility

  Scenario Outline: Contract summary
    Given I log in as a supplier with a contract in '<state>' named 'My contract'
    And I click on 'My contract'
    Then I am on the 'Contract summary' page
    Then the page should be axe clean

    Examples:
      | state       |
      | sent        |
      | accepted    |
      | signed      |
      | not_signed  |
      | declined    |
      | expired     |
      | withdrawn   |

  Scenario: Respond to contract page
    Given I log in as a supplier with a contract in 'sent' named 'My contract'
    And I click on 'My contract'
    Then I am on the 'Contract summary' page
    Then I click on 'Respond to this offer'
    And I am on the 'Respond to the contract offer' page
    Then the page should be axe clean

  Scenario: Contract accepted page
    Given I log in as a supplier with a contract in 'sent' named 'My contract'
    And I click on 'My contract'
    Then I am on the 'Contract summary' page
    Then I click on 'Respond to this offer'
    And I am on the 'Respond to the contract offer' page
    And I respond to this contract offer with 'Yes'
    When I click on 'Confirm and continue'
    Then I am on the 'You have accepted this contract offer' page
    Then the page should be axe clean
  
  Scenario: Contract declined page
    Given I log in as a supplier with a contract in 'sent' named 'My contract'
    And I click on 'My contract'
    Then I am on the 'Contract summary' page
    Then I click on 'Respond to this offer'
    And I am on the 'Respond to the contract offer' page
    And I respond to this contract offer with 'No'
    And I enter the reason for declining the contract:
      | Some reason|
    When I click on 'Confirm and continue'
    Then I am on the 'You have declined this contract offer' page
    Then the page should be axe clean
