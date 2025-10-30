Feature: Service selection and annual contract cost result in correct sub lot

  Background: Navigate to the services page
    Given I sign in and navigate to my account for 'RM6378'
    And I click on 'Search for suppliers'
    Then I am on the 'Services' page

  Scenario Outline: Select only hard services
    When I select the following items:
      | Mechanical and Electrical Engineering Maintenance |
      | Asbestos Management                               |
      | Energy and utilities management bureau Services   |
    And I click on 'Continue'
    Then I am on the 'Regions' page
    Then I select the following items:
      | Tees Valley |
      | Essex       |
    And I click on 'Continue'
    Then I am on the 'Annual contract cost' page
    And I enter '<estimated_annual_cost>' for the annual contract cost
    And I click on 'Continue'
    Then I am on the 'Results' page
    And I should be in the following sub-lots:
      | <sublot> |

    Examples:
      | estimated_annual_cost | sublot |
      | 2000000               | 2a     |
      | 2500000               | 2b     |

  Scenario Outline: Select only soft services
    When I select the following items:
      | Hard Landscaping Services  |
      | Deli / coffee bar          |
      | Cleaning of external areas |
    And I click on 'Continue'
    Then I am on the 'Regions' page
    Then I select the following items:
      | Tees Valley |
      | Essex       |
    And I click on 'Continue'
    Then I am on the 'Annual contract cost' page
    And I enter '<estimated_annual_cost>' for the annual contract cost
    And I click on 'Continue'
    Then I am on the 'Results' page
    And I should be in the following sub-lots:
      | <sublot> |

    Examples:
      | estimated_annual_cost | sublot |
      | 2000000               | 3a     |
      | 2500000               | 3b     |

  Scenario Outline: Select only total services
    When I select the following items:
      | End-User Accommodation Services       |
      | Applications And Allocations Services |
      | Third Party Claims                    |
    And I click on 'Continue'
    Then I am on the 'Regions' page
    Then I select the following items:
      | Tees Valley |
      | Essex       |
    And I click on 'Continue'
    Then I am on the 'Annual contract cost' page
    And I enter '<estimated_annual_cost>' for the annual contract cost
    And I click on 'Continue'
    Then I am on the 'Results' page
    And I should be in the following sub-lots:
      | <sublot> |

    Examples:
      | estimated_annual_cost | sublot |
      | 1499999               | 1a     |
      | 6999999               | 1b     |
      | 16000000              | 1c     |

  Scenario Outline: Select only security services
    When I select the following items:
      | <service_1_name> |
      | <service_2_name> |
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
      | <sublot> |

    Examples:
      | service_1_name                                                                     | service_2_name                                        | sublot |
      | Security Officer Services                                                          | Security Assessments                                  | 4a     |
      | Security Officer Services                                                          | Video Surveillance Systems (VSS) and Alarm Monitoring | 4b     |
      | Design, Supply, Install and Commission of Physical and Electronic Security Systems | Security Operations Centre                            | 4c     |
      | Security Advisory Services                                                         | Security Assessments                                  | 4d     |

  Scenario: FM services and FM security services
    When I select the following items:
      | Mechanical and Electrical Engineering Maintenance     |
      | Asbestos Management                                   |
      | Energy and utilities management bureau Services       |
      | Security Officer Services                             |
      | Video Surveillance Systems (VSS) and Alarm Monitoring |
    And I click on 'Continue'
    Then I am on the 'Regions' page
    Then I select the following items:
      | Tees Valley |
      | Essex       |
    And I click on 'Continue'
    Then I am on the 'Annual contract cost' page
    And I enter '2500000' for the annual contract cost
    And I click on 'Continue'
    Then I am on the 'Results' page
    And I should be in the following sub-lots:
      | 1b |

  Scenario Outline: FM services and non-FM security services
    When I select the following items:
      | Mechanical and Electrical Engineering Maintenance |
      | Asbestos Management                               |
      | Energy and utilities management bureau Services   |
      | <service_1_name>                                  |
      | <service_2_name>                                  |
    And I click on 'Continue'
    Then I am on the 'Regions' page
    Then I select the following items:
      | Tees Valley |
      | Essex       |
    And I click on 'Continue'
    Then I am on the 'Annual contract cost' page
    And I enter '2500000' for the annual contract cost
    And I click on 'Continue'
    Then I am on the 'Results' page
    And I should be in the following sub-lots:
      | 2b       |
      | <sublot> |

    Examples:
      | service_1_name                                                                     | service_2_name             | sublot |
      | Security Officer Services                                                          | Security Assessments       | 4a     |
      | Design, Supply, Install and Commission of Physical and Electronic Security Systems | Security Operations Centre | 4c     |
      | Security Advisory Services                                                         | Security Assessments       | 4d     |
