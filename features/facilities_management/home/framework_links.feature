Feature: Framwork link
  Scenario Outline: Go to old start pages
    When I visit '<url>'
    Then I am on the 'Find a facilities management supplier' page
    Then the following content should be displayed on the page:
      | Use this service to:                                                                                                        |
      | Direct award is only available for contracts less than £1.5 million, and can only be awarded to the lowest priced supplier. |
      | Before you start                                                                                                            |
      | View further information about the Facilities Management framework RM3830                                                   |
      | Start now                                                                                                                   |

  Examples:
    | url                           |
    | /facilities-management        |
    | /facilities-management/       |
    | /facilities-management/start  |
