Feature: Prices and variance - validations

  Background: Navigate to the services and prices page
    Given I sign in as an admin and navigate to the 'RM3830' dashboard
    And I click on 'Supplier framework data'
    Then I am on the 'Supplier framework data' page
    Given I show all sections
    And select 'Services' for sublot '1a' for 'Halvorson, Corwin and O\'Connell'
    Then I am on the 'Sub-lot 1a services, prices, and variances' page

  Scenario Outline: Direct award discount validations
    Given I enter '<da_discount>' into the Direct award discount filed for 'C.1 Mechanical and electrical engineering maintenance'
    And I click on 'Save and return to supplier framework data'
    Then I should see the following error messages:
      | <error_message> |

    Examples:
      | da_discount             | error_message                                       |
      | hello                   | The rate must be a number, like 0.26 or 1           |
      | -0.5                    | The rate must be greater than or equal to 0         |
      | 1.001                   | The rate must be less than or equal to 1            |
      | 0.012345670000000000001 | The rate muse not have more than 20 decimal places  |


  Scenario Outline: Variances (%) validations
    Given I enter '<variance>' into the variance for 'Corporate overhead (%)'
    And I click on 'Save and return to supplier framework data'
    Then I should see the following error messages:
      | <error_message> |

    Examples:
      | variance                | error_message                                       |
      | hello                   | The rate must be a number, like 0.26 or 1           |
      | -0.5                    | The rate must be greater than or equal to 0         |
      | 1.001                   | The rate must be less than or equal to 1            |
      | 0.012345670000000000001 | The rate muse not have more than 20 decimal places  |


  Scenario Outline: Variances (£) validations
    Given I enter '<variance>' into the variance for 'Cleaning consumables per building user (£) '
    And I click on 'Save and return to supplier framework data'
    Then I should see the following error messages:
      | <error_message> |

    Examples:
      | variance  | error_message                               |
      | hello     | The rate must be a number, like 0.26 or 1   |
      | -0.5      | The rate must be greater than or equal to 0 |
  
  Scenario Outline: Service price validations - not a number
    Given I enter 'hello' into the price for '<service>' under '<building_type>'
    And I click on 'Save and return to supplier framework data'
    Then I should see the following error messages:
      | <error_message> |

    Examples:
      | service                                             | building_type             | error_message                             |
      | C.5 Lifts, hoists & conveyance systems maintenance  | Special Schools           | The rate must be a number, like 0.26 or 1 |
      | G.6 Window cleaning (internal)                      | Warehouses                | The rate must be a number, like 0.26 or 1 |
      | J.1 Manned guarding service                         | Universities and Colleges | The rate must be a number, like 0.26 or 1 |
  
  Scenario Outline: Service price validations - less than 0
    Given I enter '-0.5' into the price for '<service>' under '<building_type>'
    And I click on 'Save and return to supplier framework data'
    Then I should see the following error messages:
      | <error_message> |

    Examples:
      | service                                             | building_type             | error_message                               |
      | C.5 Lifts, hoists & conveyance systems maintenance  | Special Schools           | The rate must be greater than or equal to 0 |
      | G.6 Window cleaning (internal)                      | Warehouses                | The rate must be greater than or equal to 0 |
      | J.1 Manned guarding service                         | Universities and Colleges | The rate must be greater than or equal to 0 |
  
  Scenario Outline: Additional services validations
    Given I enter '1.01' into the price for '<service>' under '<building_type>'
    And I click on 'Save and return to supplier framework data'
    Then I should see the following error messages:
      | <error_message> |

    Examples:
      | service               | building_type                               | error_message                             |
      | M.1 CAFM system       | Community - Doctors, Dentist, Health Clinic | The rate must be less than or equal to 1  |
      | N.1 Helpdesk services | Restaurant and Catering Facilities          | The rate must be less than or equal to 1  |