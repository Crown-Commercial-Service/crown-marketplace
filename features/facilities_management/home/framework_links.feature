Feature: Framwork link

  Scenario Outline: Go to old start pages
    When I visit '<url>'
    Then I am on the 'Find a facilities management supplier' page
    Then the following content should be displayed on the page:
      | Use this service to:                                                                             |
      | quickly view suppliers who can provide services to your locations                                |
      | download a shortlist of potential suppliers                                                      |
      | receive a compliant Lot recommendation                                                           |
      | Before you start                                                                                 |
      | which services you want to have provided                                                         |
      | where your buildings are located                                                                 |
      | your current or estimated annual cost                                                            |
      | View further information about the Facilities Management and Workplace Services framework RM6378 |
      | Start now                                                                                        |

    Examples:
      | url                          |
      | /facilities-management       |
      | /facilities-management/      |
      | /facilities-management/start |
