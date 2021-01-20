Feature: Buildings

  Background: Navigate to buildings page
    Given I sign in and navigate to my account
    And I have buildings
    And I click on 'Manage my buildings'
    Then I am on the 'Buildings' page

  Scenario: Add a building - validation error messages - empty fields
    And I click on 'Add a building'
    Then I am on the 'Add a building' page
    And I click on 'Save and continue'
    Then I should see the following error messages:
      |Enter a name for your building       |
      |Enter a valid postcode, like AA1 1AA |
