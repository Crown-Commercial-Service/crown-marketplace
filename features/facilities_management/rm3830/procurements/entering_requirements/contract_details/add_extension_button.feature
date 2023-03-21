@javascript
Feature: Add extension button

  Background: Navigate to the contract period page
    Given I sign in and navigate to my account for 'RM3830'
    And I have an empty procurement for entering requirements named 'My empty procurement'
    When I navigate to the procurement 'My empty procurement'
    Then I am on the 'Requirements' page
    And I click on 'Contract period'
    And I am on the 'Contract period' page

  Scenario: How the button changes with different values input
    Given I enter '4' year and '8' months for the contract period
    And I enter an inital call-off period start date 2 years and 3 months into the future
    And I select 'No' for mobilisation period required
    And I select 'Yes' for optional extension required
    Then the add an extension button should be 'hidden'
    Then I enter '1' years and '1' months for optional extension 1
    Then the add an extension button should be 'visible'
    And the add an extension button should have the text 'Add another extension period (4 years and 3 months remaining)'
    Then I add another extension
    And extension 2 should be 'visible'
    And the remove button for extension 2 should be 'visible'
    Then I add another extension
    And extension 3 should be 'hidden'
    And the remove button for extension 3 should be 'hidden'
    Then I enter '1' years and '0' months for optional extension 2
    And the add an extension button should have the text 'Add another extension period (3 years and 3 months remaining)'
    Then I enter '0' years and '0' months for optional extension 2
    And the add an extension button should have the text 'Add another extension period (3 years and 3 months remaining)'
    Then I add another extension
    And extension 3 should be 'hidden'
    And the remove button for extension 3 should be 'hidden'
    Then I enter '0' years and '1' months for optional extension 2
    And the add an extension button should have the text 'Add another extension period (4 years and 2 months remaining)'
    Then I add another extension
    And extension 3 should be 'visible'
    And the remove button for extension 3 should be 'visible'
    And the remove button for extension 2 should be 'hidden'
    Then I enter '1' years and '1' months for optional extension 3
    And the add an extension button should have the text 'Add another extension period (3 years and 1 month remaining)'
    And I enter '0' years and '0' months for the contract period
    Then I add another extension
    And extension 4 should be 'hidden'
    And the remove button for extension 4 should be 'hidden'
    Then I enter '9' year and '11' months for the contract period
    And the add an extension button should be 'hidden'
    Then I enter '4' year and '8' months for the contract period
    And the add an extension button should be 'visible'
    And the add an extension button should have the text 'Add another extension period (3 years and 1 month remaining)'
    And I select 'Yes' for mobilisation period required
    Then I add another extension
    And extension 4 should be 'hidden'
    And the remove button for extension 4 should be 'hidden'
    Then I enter '4' weeks for the mobilisation period
    And the add an extension button should have the text 'Add another extension period (3 years remaining)'
    Then I add another extension
    And extension 4 should be 'visible'
    And the remove button for extension 4 should be 'visible'
    And the remove button for extension 3 should be 'hidden'
    And the add an extension button should be 'hidden'
    Then I enter '0' years and '0' months for optional extension 4
    And I remove extension period 4
    And the add an extension button should be 'visible'
    And the add an extension button should have the text 'Add another extension period (3 years remaining)'
    And extension 4 should be 'hidden'
    And the remove button for extension 4 should be 'hidden'
    And the remove button for extension 3 should be 'visible'
    Then I enter '4' years and '0' months for optional extension 3
    And the add an extension button should be 'visible'
    And the add an extension button should have the text 'Add another extension period (1 month remaining)'
    Then I enter '5' weeks for the mobilisation period
    And the add an extension button should be 'hidden'
    And I click on 'Save and return'
    And I am on the 'Contract period summary' page

  Scenario: Button is not visibile with invalid data
    Given I enter '4' year and '8' months for the contract period
    And I enter an inital call-off period start date 2 years and 3 months into the future
    And I select 'No' for mobilisation period required
    And I select 'Yes' for optional extension required
    Then the add an extension button should be 'hidden'
    Then I enter '1' years and '1' months for optional extension 1
    Then the add an extension button should be 'visible'
    Then I add another extension
    Given I click on 'Save and return'
    Then I should see the following error messages:
      | Enter the years for the extension period  |
      | Enter the months for the extension period |
    Then the add an extension button should be 'hidden'
    Then I enter '1' years and '5' months for optional extension 2
    Then the add an extension button should be 'visible'
    And the add an extension button should have the text 'Add another extension period (2 years and 10 months remaining)'