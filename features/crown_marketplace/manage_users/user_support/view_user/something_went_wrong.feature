Feature: Manage users - User support - View user - Something went wron

  Scenario: View user - Service error
    Given I sign in as an 'user support' user go to the crown marketplace dashboard
    When I click on 'Manage users'
    Then I am on the 'Manage users' page
    Then I should not see users table
    Given I am going to do a search to find users
    And I search for 'buyer@test.com' there are the following users:
      | buyer@test.com  | enabled   |
    And I enter 'buyer@test.com' into the search
    And I click on 'Search'
    Then I should see the following users in the results:
      | buyer@test.com  | Enabled   |
    And I cannot view the user account because of the 'service' error
    And I view the user with email 'buyer@test.com'
    Then I am on the 'Crown Marketplace dashboard' page
    And there is an error notification with the message 'An error occured: service'
