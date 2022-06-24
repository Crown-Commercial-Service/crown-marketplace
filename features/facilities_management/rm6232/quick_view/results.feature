Feature: Information appears correctly on results page

  Background: Navigate to the results page
    Given I sign in and navigate to my account for 'RM6232'
    And I click on 'Search for suppliers'
    Then I am on the 'Start a procurement' page
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
    Then I am on the 'Annual contract value' page
    And I enter '123456' for the annual contract value
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
    And I should see the following 'annual contract value' in the selection summary:
      | £123,456  |

  @pipline
  Scenario: I can change the services from the results page
    Given I change the 'services' from the selection summary
    Then I am on the 'Services' page
    And I deselect the following items:
      | Building Information Modelling and Government Soft Landings |
    And I select 'Outside catering'
    And I click on 'Continue'
    Then I am on the 'Regions' page
    And I click on 'Continue'
    Then I am on the 'Annual contract value' page
    And I click on 'Continue'
    Then I am on the 'Results' page
    And I should be in sub-lot '1a'
    And I should see the following 'services' in the selection summary:
      | Mechanical and Electrical Engineering Maintenance |
      | Planned / Group re-lamping service                |
      | Outside catering                                  |

  @pipline
  Scenario: I can change the regions from the results page
    Given I change the 'regions' from the selection summary
    Then I am on the 'Regions' page
    And I deselect the following items:
      | Tees Valley and Durham  |
    And I select 'Gloucestershire, Wiltshire and Bristol/Bath area'
    And I click on 'Continue'
    Then I am on the 'Annual contract value' page
    And I click on 'Continue'
    Then I am on the 'Results' page
    And I should be in sub-lot '2a'
    And I should see the following 'regions' in the selection summary:
      | Essex                                             |
      | Gloucestershire, Wiltshire and Bristol/Bath area  |

  @pipline
  Scenario: I can change the annual contract value from the results page
    Given I change the 'annual contract value' from the selection summary
    Then I am on the 'Annual contract value' page
    And I enter '123456789' for the annual contract value
    And I click on 'Continue'
    Then I am on the 'Results' page
    And I should be in sub-lot '2c'
    And I should see the following 'annual contract value' in the selection summary:
      | £123,456,789  |

  Scenario: Save and return goes to the dashboard
    Then I enter 'Colony 4 procurement' into the contract name field
    And I click on 'Save and return to procurements dashboard'
    Then I am on the 'Saved searches' page
    And the procurement 'Colony 4 procurement' is on the dashboard
    And the RM6232 procurement 'Colony 4 procurement' should have the state 'Completed search'
    Then I click on 'Colony 4 procurement'
    And I am on the 'What do I do next?' page
    And the procurement name is shown to be 'Colony 4 procurement'

  Scenario: Save and continue to 'What do I do next?'
    Then I enter 'Agnis search' into the contract name field
    And I click on 'Save and continue'
    Then I am on the 'What do I do next?' page
    And the procurement name is shown to be 'Agnis search'
    And I click on 'Return to saved searches'
    And the procurement 'Agnis search' is on the dashboard
    And the RM6232 procurement 'Agnis search' should have the state 'Completed search'
