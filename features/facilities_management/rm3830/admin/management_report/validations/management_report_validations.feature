@pipeline
Feature: Management report  - validations

  Background: Navigate to the management report page
    Given I sign in as an admin and navigate to the 'RM3830' dashboard
    And I click on 'Management report'
    Then I am on the 'Generate management report' page

  Scenario Outline: Blank date validation
    And I enter 'yesterday' as the '<date_type>' date
    And I click on 'Generate and download report'
    Then I should see the following error messages:
      | <error_message> |

    Examples:
      | date_type | error_message             |
      | From      | Enter a valid ‘To’ date   |
      | To        | Enter a valid ‘From’ date |

  Scenario Outline: From date validation
    Given I enter '<date>' as the 'From' date
    And I enter 'today' as the 'To' date
    And I click on 'Generate and download report'
    Then I should see the following error messages:
      | <error_message> |

    Examples:
      | date        | error_message                                 |
      | tomorrow    | The ‘From’ date must be today or in the past  |
      | 89/45/0161  | Enter a valid ‘From’ date                     |
      | a/b/c       | Enter a valid ‘From’ date                     |

  Scenario Outline: From date validation
    Given I enter '<date>' as the 'To' date
    And I enter 'today' as the 'From' date
    And I click on 'Generate and download report'
    Then I should see the following error messages:
      | <error_message> |

    Examples:
      | date      | error_message                                           |
      | tomorrow  | The ‘To’ date must be today or in the past              |
      | yesterday | The ‘To’ date must be the same or after the ‘From’ date |
      | 29/2/2021 | Enter a valid ‘To’ date                                 |
      | a/b/c     | Enter a valid ‘To’ date                                 |
