@javascript @add_address
Feature: Building type - validations

  Background: Navigate to Building type page
    Given I sign in and navigate to my account for 'RM3830'
    And I click on 'Manage my buildings'
    Then I am on the 'Buildings' page
    And I click on 'Add a building'
    Then I am on the 'Add a building' page
    And I enter 'New building' for the building name
    And I enter the following details into the form:
      | Postcode  | ST16 1AA  |
    And I click on 'Find address'
    And I select 'Stafford Delivery Office, Newport Road, Stafford' from the address drop down
    And I click on 'Save and continue'
    Then I am on the 'Internal and external areas' page
    And I click on 'Skip this step'
    Then I am on the 'Building type' page

  Scenario Outline: I select nothing
    And I click on '<save_button>'
    Then I should see the following error messages:
      | You must select a building type or describe your own  |

    Examples:
      | save_button                                   |
      | Save and continue                             |
      | Save and return to building details summary   |

  Scenario:
    And I open the 'View more building types' details
    And I select 'Other' for the building type
    And I click on 'Save and continue'
    Then I should see the following error messages:
      | You must enter your description of a building type  |
