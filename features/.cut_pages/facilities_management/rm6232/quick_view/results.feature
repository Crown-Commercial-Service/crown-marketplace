Feature: Information appears correctly on results page

  Background: Navigate to the results page
    Given I sign in and navigate to my account for 'RM6232'
    And I click on 'Search for suppliers'
    Then I am on the 'Search for suppliers' page
    And I click on 'Continue'
    Then I am on the 'Services' page
    Then I select the following items:
      | Mechanical and Electrical Engineering Maintenance           |
      | Planned / Group re-lamping service                          |
      | Building Information Modelling and Government Soft Landings |
    And I click on 'Continue'
    Then I am on the 'Regions' page
    Then I select the following items:
      | Tees Valley and Durham  |
      | Essex                   |
    And I click on 'Continue'
    Then I am on the 'Annual contract cost' page
    And I enter '123456' for the annual contract cost
    And I click on 'Continue'
    Then I am on the 'Results' page
    And I should be in sub-lot '2a'
    And I should see the following 'services' in the selection summary:
      | Mechanical and Electrical Engineering Maintenance           |
      | Planned / Group re-lamping service                          |
      | Building Information Modelling and Government Soft Landings |
    And I should see the following 'regions' in the selection summary:
      | Tees Valley and Durham  |
      | Essex                   |
    And I should see the following 'annual contract cost' in the selection summary:
      | £123,456  |

  @pipeline 
  Scenario: Contract name and service selection saved in requirements
    Then I enter 'Mechonis field contract' into the contract name field
    And I click on 'Save and continue'
    Then I am on the 'What do I do next' page
    And I click on 'Save and continue'
    Then I am on the 'Further service and contract requirements' page
    And the procurement name is shown to be 'Mechonis field contract'
    And 'Contract name' should have the status 'COMPLETED' in 'Contract details'
    And 'Annual contract cost' should have the status 'COMPLETED' in 'Contract details'
    And 'Services' should have the status 'Completed' in 'Services and buildings'
    And I click on 'Services'
    Then I am on the 'Services summary' page
    And I should see the following seleceted services in the summary:
      | Mechanical and Electrical Engineering Maintenance           |
      | Planned / Group re-lamping service                          |
      | Building Information Modelling and Government Soft Landings |
