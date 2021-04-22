@accessibility @javascript
Feature: Estimated annual cost accessibility

  Scenario: Estimated annual cost page
    Given I sign in and navigate to my account
    And I have an empty procurement for entering requirements named 'My empty procurement'
    When I navigate to the procurement 'My empty procurement'
    Then I am on the 'Requirements' page
    And I click on 'Estimated annual cost'
    And I am on the 'Estimated annual cost' page
    Then the page should be axe clean