@accessibility @javascript
Feature: No more suppliers accessibility

  Scenario: There are no more suppliers
    Given I sign in and navigate to my account for 'RM3830'
    And I have a contract that has been 'declined' called 'No more suppliers' and there are no more suppliers
    And I click on 'Continue a procurement'
    Then I navigate to the contract 'No more suppliers' in 'Sent offers'
    Then I click on "View next supplier's price"
    And I am on the 'Supplier shortlist' page
    Then the page should be axe clean
