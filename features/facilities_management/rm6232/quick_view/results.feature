@pipline
Feature: Information appears correctly on results page

  Background: Navigate to the results page
    Given I sign in and navigate to my account for 'RM6232'
    And I click on 'Start a procurement'
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

  Scenario: I can change the annual contract value from the results page
    Given I change the 'annual contract value' from the selection summary
    Then I am on the 'Annual contract value' page
    And I enter '123456789' for the annual contract value
    And I click on 'Continue'
    Then I am on the 'Results' page
    And I should be in sub-lot '2c'
    And I should see the following 'annual contract value' in the selection summary:
      | £123,456,789  |
