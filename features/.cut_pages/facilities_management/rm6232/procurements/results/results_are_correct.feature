Feature: Information appears correctly on results page

  Background: Navigate to the further service requirements page and fill in some details
    Given I sign in and navigate to my account for 'RM6232'
    Given I have buildings
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
    Then I am on the 'Annual contract cost' page
    And I enter '123456' for the annual contract cost
    And I click on 'Continue'
    Then I am on the 'Results' page
    And I should be in sub-lot '2a'
    Then I enter 'Procurement for results' into the contract name field
    And I click on 'Save and continue'
    Then I am on the 'What happens next' page
    And I click on 'Save and continue'
    Then I am on the 'Further service and contract requirements' page
    And I click on 'TUPE'
    And I am on the 'TUPE' page
    Given I select 'No' for TUPE required
    When I click on 'Save and return'
    Then I am on the 'Further service and contract requirements' page
    And 'TUPE' should have the status 'COMPLETED' in 'Contract details'
    And I click on 'Contract period'
    And I am on the 'Contract period' page
    Given I enter an inital call-off period start date 2 years and 3 months into the future
    Then I enter '3' years and '0' months for the contract period
    And I select 'No' for mobilisation period required
    And I select 'No' for optional extension required
    When I click on 'Save and return'
    Then I am on the 'Contract period summary' page
    Given I click on 'Return to requirements'
    Then I am on the 'Further service and contract requirements' page
    And 'Contract period' should have the status 'COMPLETED' in 'Contract details'
    And I click on 'Services'
    Then I am on the 'Services summary' page
    Then I click on 'Change'
    Then I am on the 'Services' page
    And I select the following items:
      | Hard Landscaping Services     |
      | Deli / coffee bar             |
      | Deep (periodic) cleaning      |
      | Linen and laundry Services    |
      | Repairperson Services         |
      | Control of access - Vehicles  |
      | Sports and leisure            |
      | CAFM system                   |
    And I click on 'Save and return'
    Then I am on the 'Services summary' page
    And I click on 'Return to requirements'
    Then I am on the 'Further service and contract requirements' page
    And 'Services' should have the status 'COMPLETED' in 'Services and buildings'
    And I click on 'Buildings'
    Then I am on the 'Buildings' page
    And I find and select the following buildings:
      | Test building         |
      | Test London building  |
    And I click on 'Save and return'
    Then I am on the 'Buildings summary' page
    And I click on 'Return to requirements'
    Then I am on the 'Further service and contract requirements' page
    And 'Buildings' should have the status 'COMPLETED' in 'Services and buildings'

  Scenario Outline: I select total services
    And I click on 'Annual contract cost'
    And I am on the 'Annual contract cost' page
    And I enter '<annual_contract_value>' for annual contract cost
    And I click on 'Save and return'
    Then I am on the 'Further service and contract requirements' page
    And 'Annual contract cost' should have the status 'COMPLETED' in 'Contract details'
    And I click on 'Assigning services to buildings'
    Then I am on the 'Assigning services to buildings summary' page
    Given I click on 'Test building' 
    Then I am on the 'Test building' page
    And I am on the page with secondary heading 'Which of your services are required within this building?'
    When I select the following services for the building:
      | Mechanical and Electrical Engineering Maintenance |
      | Deli / coffee bar                                 |
      | Repairperson Services                             |
      | CAFM system                                       |
    And I click on 'Save and return'
    Then I am on the 'Assigning services to buildings summary' page
    Given I click on 'Test London building' 
    Then I am on the 'Test London building' page
    And I am on the page with secondary heading 'Which of your services are required within this building?'
    When I select the following services for the building:
      | Mechanical and Electrical Engineering Maintenance |
      | Control of access - Vehicles                      |
      | Sports and leisure                                |
    And I click on 'Save and return'
    Then I am on the 'Assigning services to buildings summary' page
    And the assigning services to buildings status should be 'COMPLETED'
    Then I click on 'Return to requirements'
    And I am on the 'Further service and contract requirements' page
    And 'Assigning services to buildings' should have the status 'COMPLETED' in 'Services and buildings'
    And everything is completed
    And I click on 'Save and continue'
    Then I am on the 'Results' page
    And my sublot is '1<lot_letter>'
    And there are <number_of_suppliers> suppliers shortlisted
    And I have 2 buildings in my results
    And the buildings in my results are:
      | Test building         |
      | Test London building  |
    And I have 6 services in my results
    And the services in my results are:
      | Mechanical and Electrical Engineering Maintenance |
      | Deli / coffee bar                                 |
      | Repairperson Services                             |
      | Control of access - Vehicles                      |
      | Sports and leisure                                |
      | TFM & Hard FM CAFM Requirements                   |

  Examples:
      | annual_contract_value | lot_letter  | number_of_suppliers |
      | 50000                 | a           | 14                  |
      | 5000000               | b           | 13                  |
      | 50000000              | c           | 13                  |

  @pipeline
  Scenario Outline: I select hard services
    And I click on 'Annual contract cost'
    And I am on the 'Annual contract cost' page
    And I enter '<annual_contract_value>' for annual contract cost
    And I click on 'Save and return'
    Then I am on the 'Further service and contract requirements' page
    And 'Annual contract cost' should have the status 'COMPLETED' in 'Contract details'
    And I click on 'Assigning services to buildings'
    Then I am on the 'Assigning services to buildings summary' page
    Given I click on 'Test building' 
    Then I am on the 'Test building' page
    And I am on the page with secondary heading 'Which of your services are required within this building?'
    When I select the following services for the building:
      | Mechanical and Electrical Engineering Maintenance |
      | CAFM system                                       |
    And I click on 'Save and return'
    Then I am on the 'Assigning services to buildings summary' page
    Given I click on 'Test London building' 
    Then I am on the 'Test London building' page
    And I am on the page with secondary heading 'Which of your services are required within this building?'
    When I select the following services for the building:
      | Planned / Group re-lamping service                          |
      | Building Information Modelling and Government Soft Landings |
    And I click on 'Save and return'
    Then I am on the 'Assigning services to buildings summary' page
    And the assigning services to buildings status should be 'COMPLETED'
    Then I click on 'Return to requirements'
    And I am on the 'Further service and contract requirements' page
    And 'Assigning services to buildings' should have the status 'COMPLETED' in 'Services and buildings'
    And everything is completed
    And I click on 'Save and continue'
    Then I am on the 'Results' page
    And my sublot is '2<lot_letter>'
    And there are <number_of_suppliers> suppliers shortlisted
    And I have 2 buildings in my results
    And the buildings in my results are:
      | Test building         |
      | Test London building  |
    And I have 4 services in my results
    And the services in my results are:
      | Mechanical and Electrical Engineering Maintenance           |
      | Planned / Group re-lamping service                          |
      | Building Information Modelling and Government Soft Landings |
      | TFM & Hard FM CAFM Requirements                             |

  Examples:
      | annual_contract_value | lot_letter  | number_of_suppliers |
      | 50000                 | a           | 14                  |
      | 5000000               | b           | 13                  |
      | 50000000              | c           | 13                  |

  Scenario Outline: I select soft services
    And I click on 'Annual contract cost'
    And I am on the 'Annual contract cost' page
    And I enter '<annual_contract_value>' for annual contract cost
    And I click on 'Save and return'
    Then I am on the 'Further service and contract requirements' page
    And 'Annual contract cost' should have the status 'COMPLETED' in 'Contract details'
    And I click on 'Assigning services to buildings'
    Then I am on the 'Assigning services to buildings summary' page
    Given I click on 'Test building' 
    Then I am on the 'Test building' page
    And I am on the page with secondary heading 'Which of your services are required within this building?'
    When I select the following services for the building:
      | Deep (periodic) cleaning      |
      | Control of access - Vehicles  |
      | CAFM system                   |
    And I click on 'Save and return'
    Then I am on the 'Assigning services to buildings summary' page
    Given I click on 'Test London building' 
    Then I am on the 'Test London building' page
    And I am on the page with secondary heading 'Which of your services are required within this building?'
    When I select the following services for the building:
      | Deli / coffee bar             |
      | Deep (periodic) cleaning      |
      | Linen and laundry Services    |
      | CAFM system                   |
    And I click on 'Save and return'
    Then I am on the 'Assigning services to buildings summary' page
    And the assigning services to buildings status should be 'COMPLETED'
    Then I click on 'Return to requirements'
    And I am on the 'Further service and contract requirements' page
    And 'Assigning services to buildings' should have the status 'COMPLETED' in 'Services and buildings'
    And everything is completed
    And I click on 'Save and continue'
    Then I am on the 'Results' page
    And my sublot is '3<lot_letter>'
    And there are <number_of_suppliers> suppliers shortlisted
    And I have 2 buildings in my results
    And the buildings in my results are:
      | Test building         |
      | Test London building  |
    And I have 5 services in my results
    And the services in my results are:
      | Deli / coffee bar             |
      | Deep (periodic) cleaning      |
      | Linen and laundry Services    |
      | Control of access - Vehicles  |
      | CAFM – Soft FM Requirements   |

  Examples:
      | annual_contract_value | lot_letter  | number_of_suppliers |
      | 50000                 | a           | 14                  |
      | 5000000               | b           | 13                  |
      | 50000000              | c           | 14                  |

