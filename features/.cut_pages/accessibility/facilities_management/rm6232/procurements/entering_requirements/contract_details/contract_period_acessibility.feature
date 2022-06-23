@accessibility @javascript
Feature: Contract period accessibility

  Background: Navigate to the contract period page
    Given I sign in and navigate to my account for 'RM6232'
    And I have an empty procurement for entering requirements named 'My empty procurement'
    When I navigate to the procurement 'My empty procurement'
    Then I am on the 'Further service and contract requirements' page
    And I click on 'Contract period'
    And I am on the 'Contract period' page

  Scenario: Contract period page
    Then the page should be axe clean

  Scenario: Contract period summary page - no extra options
    Given I enter an inital call-off period start date 2 years and 3 months into the future
    Then I enter '3' years and '6' months for the contract period
    And I select 'No' for mobilisation period required
    And I select 'No' for optional extension required
    When I click on 'Save and return'
    Then I am on the 'Contract period summary' page
    Then the page should be axe clean

  Scenario: Contract period summary page - with extra options
    Given I enter an inital call-off period start date 2 years and 1 months into the future
    Then I enter '2' years and '7' months for the contract period
    And I select 'Yes' for mobilisation period required
    Then I enter '6' weeks for the mobilisation period
    And I select 'Yes' for optional extension required
    Then I enter '0' years and '1' months for optional extension 1
    And I add another extension
    Then I enter '1' years and '0' months for optional extension 2
    And I add another extension
    Then I enter '1' years and '2' months for optional extension 3
    And I add another extension
    Then I enter '3' years and '7' months for optional extension 4
    When I click on 'Save and return'
    Then I am on the 'Contract period summary' page
    Then the page should be axe clean