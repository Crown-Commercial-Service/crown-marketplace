Feature: Start pages

  Scenario: Buyer sees start page
    When I go to the facilities management RM3830 start page
    Then I am on the 'Find a facilities management supplier' page

  Scenario: Buyer navigatis to sign in page
    When I go to the facilities management RM3830 start page
    And I am on the 'Find a facilities management supplier' page
    When I click on 'Start now'
    Then I am on the 'Sign in to your account' page

  Scenario: Logging on user without details
    When I go to the facilities management RM3830 start page
    And I am on the 'Find a facilities management supplier' page
    When I click on 'Start now'
    And I am on the 'Sign in to your account' page
    Then I should sign in as an fm buyer without details
    And I am on the 'Manage your details' page

  Scenario: Logging on user with details
    When I go to the facilities management RM3830 start page
    And I am on the 'Find a facilities management supplier' page
    When I click on 'Start now'
    And I am on the 'Sign in to your account' page
    Then I should sign in as an fm buyer with details
    And I am on the Your account page

  Scenario: Viewing the home page
    When I go to the facilities management RM3830 start page
    And I am on the 'Find a facilities management supplier' page
    When I click on 'Start now'
    And I am on the 'Sign in to your account' page
    Then I should sign in as an fm buyer with details
    And I am on the Your account page
    Then the following content should be displayed on the page:
      | Your account                                                                                                  |
      | Quick view suppliers                                                                                          |
      | Quickly view suppliers who can provide services to your locations                                             |
      | Start a procurement                                                                                           |
      | See shortlisted suppliers, estimated contract costs, and explore direct award or further competition options  |
      | Continue a procurement                                                                                        |
      | Manage my buildings                                                                                           |
      | Set up and manage your buildings for use in procurements                                                      |
      | Manage my details                                                                                             |
      | Update and edit your contact details                                                                          |