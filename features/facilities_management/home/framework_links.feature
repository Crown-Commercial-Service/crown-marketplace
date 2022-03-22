Feature: Framwork link
  Scenario Outline: Go to old start pages
    When I visit '<url>'
    Then I am on the 'Find a facilities management supplier' page
    Then the following content should be displayed on the page:
      | Use this service to:                                                      |
      | quickly view suppliers who can provide services to your locations         |
      | compliantly create your procurement bid back                              |
      | shortlist suppliers ready for further competition                         |
      | Before you start                                                          |
      | View further information about the Facilities Management framework RM6232 |
      | Start now                                                                 |

  Examples:
    | url                           |
    | /facilities-management        |
    | /facilities-management/       |
    | /facilities-management/start  |
