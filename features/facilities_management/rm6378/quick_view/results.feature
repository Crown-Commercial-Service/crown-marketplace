Feature: Information appears correctly on results page

  Background: Navigate to the results page
    Given I sign in and navigate to my account for 'RM6378'
    And I click on 'Search for suppliers'
    Then I am on the 'Services' page
    Then I select the following items:
      | Mechanical and Electrical Engineering Maintenance                       |
      | Planned / Group re-lamping service                                      |
      | Building Information Modelling (BIM) and Government Soft Landings (GSL) |
    And I click on 'Continue'
    Then I am on the 'Regions' page
    Then I select the following items:
      | Tees Valley |
      | Essex       |
    And I click on 'Continue'
    Then I am on the 'Annual contract cost' page
    And I enter '123456' for the annual contract cost
    And I click on 'Continue'
    Then I am on the 'Results' page
    And I should be in the following sub-lots:
      | 2a |
    And I should see the following 'services' in the selection summary:
      | Mechanical and Electrical Engineering Maintenance                       |
      | Planned / Group re-lamping service                                      |
      | Building Information Modelling (BIM) and Government Soft Landings (GSL) |
    And I should see the following 'regions' in the selection summary:
      | Tees Valley |
      | Essex       |
    And I should see the following 'annual contract cost' in the selection summary:
      | £123,456 |

  Scenario: I can change the services from the results page
    Given I change the 'services' from the selection summary
    Then I am on the 'Services' page
    And I deselect the following items:
      | Building Information Modelling (BIM) and Government Soft Landings (GSL) |
    And I select 'Outside catering'
    And I click on 'Continue'
    Then I am on the 'Regions' page
    And I click on 'Continue'
    Then I am on the 'Annual contract cost' page
    And I click on 'Continue'
    Then I am on the 'Results' page
    And I should be in the following sub-lots:
      | 1a |
    And I should see the following 'services' in the selection summary:
      | Mechanical and Electrical Engineering Maintenance |
      | Planned / Group re-lamping service                |
      | Outside catering                                  |

  Scenario: I can change the regions from the results page
    Given I change the 'regions' from the selection summary
    Then I am on the 'Regions' page
    And I deselect the following items:
      | Tees Valley |
    And I select 'West of England'
    And I click on 'Continue'
    Then I am on the 'Annual contract cost' page
    And I click on 'Continue'
    Then I am on the 'Results' page
    And I should be in the following sub-lots:
      | 2a |
    And I should see the following 'regions' in the selection summary:
      | Essex           |
      | West of England |

  Scenario: I can change the annual contract cost from the results page
    Given I change the 'annual contract cost' from the selection summary
    Then I am on the 'Annual contract cost' page
    And I enter '123456789' for the annual contract cost
    And I click on 'Continue'
    Then I am on the 'Results' page
    And I should be in the following sub-lots:
      | 2b |
    And I should see the following 'annual contract cost' in the selection summary:
      | £123,456,789 |

# Scenario: Save and continue to 'What do I do next?'
# Then I enter 'Agnis search' into the contract name field
# And I choose the 'Yes' radio button
# And I click on 'Save and continue'
# Then I am on the 'What do I do next?' page
# And the procurement name is shown to be 'Agnis search'
# And I click on 'Return to saved searches'
# And the procurement 'Agnis search' is on the dashboard
