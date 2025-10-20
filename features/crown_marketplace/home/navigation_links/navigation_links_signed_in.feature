@allow_list
Feature: Navigation links when signed in

  Background: Crown Marketplace admin signs in
    Given I sign in as an 'super admin' user go to the crown marketplace dashboard

  Scenario Outline: Cookies policy - <header_link>
    When I click on 'Cookie policy'
    Then I am on the 'Details about cookies on Crown Marketplace' page
    And I should see the following navigation links:
      | Crown Marketplace dashboard |
      | Sign out                    |
    And I click on '<header_link>'
    Then I am on the '<heading_text>' page

    Examples:
      | header_link                 | heading_text                        |
      | Crown Marketplace dashboard | Crown Marketplace dashboard         |
      | Sign out                    | Sign in to manage Crown Marketplace |

  Scenario Outline: Cookies settings - <header_link>
    When I click on 'Cookie settings'
    Then I am on the 'Cookies on Crown Marketplace' page
    And I should see the following navigation links:
      | Crown Marketplace dashboard |
      | Sign out                    |
    And I click on '<header_link>'
    Then I am on the '<heading_text>' page

    Examples:
      | header_link                 | heading_text                        |
      | Crown Marketplace dashboard | Crown Marketplace dashboard         |
      | Sign out                    | Sign in to manage Crown Marketplace |

  Scenario Outline: Accessibility statement - <header_link>
    When I click on 'Accessibility statement'
    Then I am on the 'Facilities Management (FM) Accessibility statement' page
    And I should see the following navigation links:
      | Crown Marketplace dashboard |
      | Sign out                    |
    And I click on '<header_link>'
    Then I am on the '<heading_text>' page

    Examples:
      | header_link                 | heading_text                        |
      | Crown Marketplace dashboard | Crown Marketplace dashboard         |
      | Sign out                    | Sign in to manage Crown Marketplace |

  Scenario Outline: Crown Marketplace dashboard - <header_link>
    And I should see the following navigation links:
      | Crown Marketplace dashboard |
      | Sign out                    |
    And I click on '<header_link>'
    And I am on the '<heading_text>' page

    Examples:
      | header_link                 | heading_text                        |
      | Crown Marketplace dashboard | Crown Marketplace dashboard         |
      | Sign out                    | Sign in to manage Crown Marketplace |

  @allow_list
  Scenario Outline: Crown Marketplace admin page - <header_link>
    When I click on 'Allow list'
    Then I am on the 'Allow list' page
    And I should see the following navigation links:
      | Crown Marketplace dashboard |
      | Sign out                    |
    And I click on '<header_link>'
    Then I am on the '<heading_text>' page

    Examples:
      | header_link                 | heading_text                        |
      | Crown Marketplace dashboard | Crown Marketplace dashboard         |
      | Sign out                    | Sign in to manage Crown Marketplace |
