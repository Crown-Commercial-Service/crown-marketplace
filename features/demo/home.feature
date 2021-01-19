Feature:  Facilities Management - Home Page Content

  Scenario:
    Given I am a logged in user
    Then the following home page content is displayed:
      | Your account                                                                                                        |
      | Quick view suppliers                                                                                                |
      | Quickly view suppliers who can provide services to your locations                                                   |
      | Start a procurement                                                                                                 |
      | See shortlisted suppliers, estimated contract costs, and explore direct award or further competition options        |
      | Continue a procurement                                                                                              |
      | Open your procurements dashboard to view and continue existing saved procurements                                   |
      | Manage my buildings                                                                                                 |
      | Set up and manage your buildings for use in procurements                                                            |
      | Manage my details                                                                                                   |
      | Update and edit your contact details                                                                                |
    When I click on "Continue a procurement"
    Then I should see header "Procurements dashboard"