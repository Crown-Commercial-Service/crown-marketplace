Feature: Service and selection and annual contract cost result in correct sub lot

  Background: Navigate to the services page
    Given I sign in and navigate to my account for 'RM6232'
    And I click on 'Search for suppliers'
    Then I am on the 'Services' page

  Scenario Outline: Select only hard services
    When I select the following items:
      | Audio Visual (AV) equipment maintenance |
      | Mail room equipment maintenance         |
      | Electrical Testing                      |
    And I click on 'Continue'
    Then I am on the 'Regions' page
    Then I select the following items:
      | Tees Valley and Durham  |
      | Essex                   |
    And I click on 'Continue'
    Then I am on the 'Annual contract cost' page
    And I enter '<estimated_annual_cost>' for the annual contract cost
    And I click on 'Continue'
    Then I am on the 'Results' page
    And I should be in sub-lot '<sublot>'

    Examples:
      | estimated_annual_cost | sublot  |
      | 1499999               | 2a      |
      | 6999999               | 2b      |
      | 11000000              | 2c      |

  Scenario Outline: Select only soft services
    When I select the following items:
      | Voice announcement system operation |
      | Archiving (on-site)                 |
      | Repairperson Services               |
    And I click on 'Continue'
    Then I am on the 'Regions' page
    Then I select the following items:
      | Tees Valley and Durham  |
      | Essex                   |
    And I click on 'Continue'
    Then I am on the 'Annual contract cost' page
    And I enter '<estimated_annual_cost>' for the annual contract cost
    And I click on 'Continue'
    Then I am on the 'Results' page
    And I should be in sub-lot '<sublot>'

    Examples:
      | estimated_annual_cost | sublot  |
      | 999999                | 3a      |
      | 6999999               | 3b      |
      | 11000000              | 3c      |

  Scenario Outline: Select only total services
    When I select the following items:
      | End-User Accommodation Services       |
      | Third Party Claims                    |
      | Special Need or Disability Adaptions  |
    And I click on 'Continue'
    Then I am on the 'Regions' page
    Then I select the following items:
      | Tees Valley and Durham  |
      | Essex                   |
    And I click on 'Continue'
    Then I am on the 'Annual contract cost' page
    And I enter '<estimated_annual_cost>' for the annual contract cost
    And I click on 'Continue'
    Then I am on the 'Results' page
    And I should be in sub-lot '<sublot>'

    Examples:
      | estimated_annual_cost | sublot  |
      | 1499999               | 1a      |
      | 6999999               | 1b      |
      | 11000000              | 1c      |

  Scenario Outline: Select hard and total services
    When I select the following items:
      | Lifts, hoists and conveyance systems maintenance  |
      | Radon Gas Management Services                     |
      | Occupancy Management                              |
      | Housing Stock Management                          |
    And I click on 'Continue'
    Then I am on the 'Regions' page
    Then I select the following items:
      | Tees Valley and Durham  |
      | Essex                   |
    And I click on 'Continue'
    Then I am on the 'Annual contract cost' page
    And I enter '<estimated_annual_cost>' for the annual contract cost
    And I click on 'Continue'
    Then I am on the 'Results' page
    And I should be in sub-lot '<sublot>'

    Examples:
      | estimated_annual_cost | sublot  |
      | 1499999               | 1a      |
      | 6999999               | 1b      |
      | 11000000              | 1c      |

  Scenario Outline: Select hard and soft/total services
    When I select the following items:
      | Locksmith Services  |
      | Asbestos Management |
      | Porterage           |
      | Routine cleaning    |
    And I click on 'Continue'
    Then I am on the 'Regions' page
    Then I select the following items:
      | Tees Valley and Durham  |
      | Essex                   |
    And I click on 'Continue'
    Then I am on the 'Annual contract cost' page
    And I enter '<estimated_annual_cost>' for the annual contract cost
    And I click on 'Continue'
    Then I am on the 'Results' page
    And I should be in sub-lot '<sublot>'

    Examples:
      | estimated_annual_cost | sublot  |
      | 1499999               | 1a      |
      | 6999999               | 1b      |
      | 11000000              | 1c      |

  Scenario Outline: Select soft and total services
    When I select the following items:
      | Specialist Health FM Services                           |
      | Reactive cleaning (outside cleaning operational hours)  |
      | Accommodation Stores Service                            |
      | Occupancy Management                                    |
    And I click on 'Continue'
    Then I am on the 'Regions' page
    Then I select the following items:
      | Tees Valley and Durham  |
      | Essex                   |
    And I click on 'Continue'
    Then I am on the 'Annual contract cost' page
    And I enter '<estimated_annual_cost>' for the annual contract cost
    And I click on 'Continue'
    Then I am on the 'Results' page
    And I should be in sub-lot '<sublot>'

    Examples:
      | estimated_annual_cost | sublot  |
      | 1499999               | 1a      |
      | 6999999               | 1b      |
      | 11000000              | 1c      |

  Scenario Outline: Select soft and hard/total services
    When I select the following items:
      | Full service restaurant                                     |
      | Planned snow and ice clearance                              |
      | Building Information Modelling and Government Soft Landings |
      | Audio Visual (AV) equipment maintenance                     |
    And I click on 'Continue'
    Then I am on the 'Regions' page
    Then I select the following items:
      | Tees Valley and Durham  |
      | Essex                   |
    And I click on 'Continue'
    Then I am on the 'Annual contract cost' page
    And I enter '<estimated_annual_cost>' for the annual contract cost
    And I click on 'Continue'
    Then I am on the 'Results' page
    And I should be in sub-lot '<sublot>'

    Examples:
      | estimated_annual_cost | sublot  |
      | 1499999               | 1a      |
      | 6999999               | 1b      |
      | 11000000              | 1c      |

  Scenario Outline: Select total and hard/soft services
    When I select the following items:
      | CAFM system                                       |
      | Management of Billable Works                      |
      | Housing and residential accommodation management  |
    And I click on 'Continue'
    Then I am on the 'Regions' page
    Then I select the following items:
      | Tees Valley and Durham  |
      | Essex                   |
    And I click on 'Continue'
    Then I am on the 'Annual contract cost' page
    And I enter '<estimated_annual_cost>' for the annual contract cost
    And I click on 'Continue'
    Then I am on the 'Results' page
    And I should be in sub-lot '<sublot>'

    Examples:
      | estimated_annual_cost | sublot  |
      | 1499999               | 1a      |
      | 6999999               | 1b      |
      | 11000000              | 1c      |

  Scenario Outline: Select hard and soft services
    When I select the following items:
      | Window cleaning (external)              |
      | Retail Services / Convenience Store     |
      | Condition surveys                       |
      | Energy Performance Certificates (EPCs)  |
    And I click on 'Continue'
    Then I am on the 'Regions' page
    Then I select the following items:
      | Tees Valley and Durham  |
      | Essex                   |
    And I click on 'Continue'
    Then I am on the 'Annual contract cost' page
    And I enter '<estimated_annual_cost>' for the annual contract cost
    And I click on 'Continue'
    Then I am on the 'Results' page
    And I should be in sub-lot '<sublot>'

    Examples:
      | estimated_annual_cost | sublot  |
      | 1499999               | 1a      |
      | 6999999               | 1b      |
      | 11000000              | 1c      |
  
  Scenario Outline: Select total, hard and soft services
    When I select the following items:
      | Mail room equipment maintenance                                                                                                           |
      | Fire detection and firefighting systems maintenance                                                                                       |
      | Journal, magazine and newspaper supply                                                                                                    |
      | Trolley service                                                                                                                           |
      | Management and Control of Ranges and Training Areas (MCRT) (including the Operation of a Bidding and Allocation Management (BAMS) system) |
      | Customer Service Centre                                                                                                                   |
    And I click on 'Continue'
    Then I am on the 'Regions' page
    Then I select the following items:
      | Tees Valley and Durham  |
      | Essex                   |
    And I click on 'Continue'
    Then I am on the 'Annual contract cost' page
    And I enter '<estimated_annual_cost>' for the annual contract cost
    And I click on 'Continue'
    Then I am on the 'Results' page
    And I should be in sub-lot '<sublot>'

    Examples:
      | estimated_annual_cost | sublot  |
      | 1499999               | 1a      |
      | 6999999               | 1b      |
      | 11000000              | 1c      |
