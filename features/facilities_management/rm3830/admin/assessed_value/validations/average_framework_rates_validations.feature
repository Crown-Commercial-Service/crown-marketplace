Feature: Average framework rates  - validations

  Background: Navigate to the average framework rates page
    Given I sign in as an admin and navigate to the 'RM3830' dashboard
    And I click on 'Average framework rates'
    Then I am on the 'Average framework rates' page

  Scenario Outline: Service price - validation
    Given I enter the servie rate of 'Rex' for '<field>'
    And I click on 'Save and return to dashboard'
    Then I should see the following error messages:
      | The rate must be a number, like 0.26 or 1 |

    Examples:
      | field                                                 |
      | C.6 Security, access and intruder systems maintenance |
      | F.8 Trolley service                                   |
      | I.1 Reception service                                 |

  Scenario Outline: Additional services price - validation
    Given I enter the servie rate of '<value>' for '<field>'
    And I click on 'Save and return to dashboard'
    Then I should see the following error messages:
      | <error_message> |

    Examples:
      | value | field                 | error_message                             |
      | Nia   | N.1 Helpdesk services | The rate must be a number, like 0.26 or 1 |
      | 1.098 | M.1 CAFM system       | The rate must be less than or equal to 1  |

  Scenario Outline: Variance validation
    Given I enter the variance of '<value>' for '<field>'
    And I click on 'Save and return to dashboard'
    Then I should see the following error messages:
      | <error_message> |

    Examples:
      | value | field                                       | error_message                             |
      | Tora  | Cleaning consumables per building user (£)  | The rate must be a number, like 0.26 or 1 |
      | 2     | Corporate overhead (%)                      | The rate must be less than or equal to 1  |
