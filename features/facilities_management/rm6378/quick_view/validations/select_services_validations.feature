Feature: Select services validations

  Background: Navigate to the services page
    Given I sign in and navigate to my account for 'RM6378'
    And I click on 'Search for suppliers'
    Then I am on the 'Services' page

  Scenario: No services selected
    And I click on 'Continue'
    Then I should see the following error messages:
      | Select at least one service you need to include in your procurement |

  Scenario Outline: Only mandatory services - one extra
    When I select the following items:
      | <service> |
    And I click on 'Continue'
    Then I should see the following error messages:
      | You must select another service to include 'CAFM system' and/or 'Helpdesk services' |

    Examples:
      | service           |
      | CAFM system       |
      | Helpdesk Services |

  Scenario: Only mandatory services - two extra
    When I select the following items:
      | CAFM system       |
      | Helpdesk Services |
    And I click on 'Continue'
    Then I should see the following error messages:
      | You must select another service to include 'CAFM system' and/or 'Helpdesk services' |
