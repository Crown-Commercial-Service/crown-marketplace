Feature: Supplier withdrawn contract

  Scenario: Withdrawn contract
    Given I log in as a supplier with a contract in 'withdrawn' named 'Withdrawn contract'
    Then I should see the following contracts on the dashboard in the section:
      | Closed  | Withdrawn contract  |
    And I click on 'Withdrawn contract'
    Then I am on the 'Contract summary' page
    Then there is a warning with the text 'Withdrawn'
    And the key details include:
      | The buyer withdrew this contract offer and closed this procurement  |
    And the buyers reason for withdrawing is:
      | I got fed up of waiting |
    And I should see the following text within the contract offer history:
      | This contract offer was received  |
    Then I click on the 'Return to dashboard' return link
    And I am on the 'Direct award dashboard' page
    And I click on 'Withdrawn contract'
    Then I click on the 'Return to dashboard' back link
    And I am on the 'Direct award dashboard' page