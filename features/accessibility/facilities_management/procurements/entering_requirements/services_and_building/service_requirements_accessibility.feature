@accessibility @javascript
Feature: Service requirements accessibility

  Scenario: Service requirements summary page
    Given I sign in and navigate to my account for 'RM3830'
    And I have buildings
    And I have an empty procurement with buildings named 'S & B procurement' with the following servcies assigned:
      | C.1 |
      | L.5 |
      | G.1 |
      | J.3 |
      | N.1 |
    When I navigate to the procurement 'S & B procurement'
    Then I am on the 'Requirements' page
    And I click on 'Service requirements'
    Then I am on the 'Service requirements summary' page
    Then the page should be axe clean