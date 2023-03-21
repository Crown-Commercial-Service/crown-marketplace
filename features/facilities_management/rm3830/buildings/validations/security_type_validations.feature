@javascript @add_address
Feature: Security type - validations

  Background: Navigate to Security type page
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
    And I click on 'Skip this step'
    Then I am on the 'Security clearance' page

  Scenario: I select nothing
    And I click on 'Save and return to building details summary'
    Then I should see the following error messages:
      | You must select a security clearance level  |

  Scenario:
    And I select 'Other' for the security type
    And I click on 'Save and return to building details summary'
    Then I should see the following error messages:
      | You must describe the security clearance level  |
