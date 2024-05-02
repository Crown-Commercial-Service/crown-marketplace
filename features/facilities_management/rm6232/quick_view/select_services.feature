@javascript
Feature: Select services
  
  Background: Navigate to the Services page
    Given I sign in and navigate to my account for 'RM6232'
    And I click on 'Search for suppliers'
    Then I am on the 'Services' page
    And I show all sections

  Scenario: Service selection appears in basked
    Then the basket should say 'No services selected'
    And the remove all link should not be visible
    When I select 'Building Management System (BMS) maintenance'
    Then the basket should say '1 service selected'
    And the remove all link should be visible
    And the following items should appear in the basket:
      | Building Management System (BMS) maintenance  |
    When I select the following items:
      | Water Hygiene Maintenance                     |
      | Pest control Services                         |
      | High Voltage (HV) and switchgear maintenance  |
      | Additional support Services                   |
      | Courier booking and distribution services     |
      | Patrols (fixed or static guarding)            |
    Then the basket should say '7 services selected'
    And the remove all link should be visible
    And the following items should appear in the basket:
      | Building Management System (BMS) maintenance  |
      | Water Hygiene Maintenance                     |
      | Pest control Services                         |
      | High Voltage (HV) and switchgear maintenance  |
      | Additional support Services                   |
      | Courier booking and distribution services     |
      | Patrols (fixed or static guarding)            |

  Scenario: Changing the selection will change the basket
    When I select the following items:
      | Water Hygiene Maintenance                     |
      | Pest control Services                         |
      | High Voltage (HV) and switchgear maintenance  |
      | Additional support Services                   |
      | Courier booking and distribution services     |
      | Patrols (fixed or static guarding)            |
    Then the basket should say '6 services selected'
    And the remove all link should be visible
    And the following items should appear in the basket:
      | Water Hygiene Maintenance                     |
      | Pest control Services                         |
      | High Voltage (HV) and switchgear maintenance  |
      | Additional support Services                   |
      | Courier booking and distribution services     |
      | Patrols (fixed or static guarding)            |
    When I deselect the following items:
      | Additional support Services |
    Then the basket should say '5 services selected'
    And the remove all link should be visible
    And the following items should appear in the basket:
      | Water Hygiene Maintenance                     |
      | Pest control Services                         |
      | High Voltage (HV) and switchgear maintenance  |
      | Courier booking and distribution services     |
      | Patrols (fixed or static guarding)            |
    When I remove the following items from the basket:
      | Pest control Services                     |
      | Courier booking and distribution services |
    Then the basket should say '3 services selected'
    And the remove all link should be visible
    And the following items should appear in the basket:
      | Water Hygiene Maintenance                     |
      | High Voltage (HV) and switchgear maintenance  |
      | Patrols (fixed or static guarding)            |
    When I click on 'Remove all'
    Then the basket should say 'No services selected'

  Scenario: Select all checkbox
    When I select all for 'Security Services'
    Then the basket should say '15 services selected'
    And the remove all link should be visible
    And the following items should appear in the basket:
      | Static Guarding Service                           |
      | CCTV / alarm monitoring                           |
      | Control of access - Staff and Visitors            |
      | Control of access - Vehicles                      |
      | Emergency response                                |
      | Patrols (fixed or static guarding)                |
      | Management of visitors and passes                 |
      | Reactive guarding                                 |
      | Additional security Services                      |
      | Enhanced security requirements                    |
      | Key holding                                       |
      | Lock Up / open up of Buyer Premises               |
      | Patrols (mobile via a specific visiting vehicle)  |
      | Remote CCTV / alarm monitoring                    |
      | Blended Static Guarding Service                   |
    When I remove the following items from the basket:
      | Enhanced security requirements |
    Then select all 'should not' be checked for 'Security Services'
    When I select 'Enhanced security requirements'
    Then select all 'should' be checked for 'Security Services'

  Scenario: Go back from regions and change selection
    When I select the following items:
      | Water Hygiene Maintenance                     |
      | Pest control Services                         |
      | Building Management System (BMS) maintenance  |
      | Additional support Services                   |
      | Courier booking and distribution services     |
    And I click on 'Continue'
    Then I am on the 'Regions' page
    And I click on the 'Return to services' back link
    Then I am on the 'Services' page
    And the following items should appear in the basket:
      | Building Management System (BMS) maintenance  |
      | Water Hygiene Maintenance                     |
      | Pest control Services                         |
      | Courier booking and distribution services     |
      | Additional support Services                   |
