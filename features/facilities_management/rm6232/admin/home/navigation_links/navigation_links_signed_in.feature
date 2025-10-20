Feature: Navigation links when signed in

  Background: Admin signs in
    Given I sign in as an admin and navigate to the 'RM6232' dashboard

  Scenario Outline: Cookies policy - <header_link>
    When I click on 'Cookie policy'
    Then I am on the 'Details about cookies on Crown Marketplace' page
    And I should see the following navigation links:
      | Admin dashboard |
      | Sign out        |
    And I click on '<header_link>'
    Then I am on the '<heading_text>' page

    Examples:
      | header_link     | heading_text                                   |
      | Admin dashboard | RM6232 administration dashboard                |
      | Sign out        | Sign in to the RM6232 administration dashboard |

  Scenario Outline: Cookies settings - <header_link>
    When I click on 'Cookie settings'
    Then I am on the 'Cookies on Crown Marketplace' page
    And I should see the following navigation links:
      | Admin dashboard |
      | Sign out        |
    And I click on '<header_link>'
    Then I am on the '<heading_text>' page

    Examples:
      | header_link     | heading_text                                   |
      | Admin dashboard | RM6232 administration dashboard                |
      | Sign out        | Sign in to the RM6232 administration dashboard |

  Scenario Outline: Accessibility statement - <header_link>
    When I click on 'Accessibility statement'
    Then I am on the 'Facilities Management (FM) Accessibility statement' page
    And I should see the following navigation links:
      | Admin dashboard |
      | Sign out        |
    And I click on '<header_link>'
    Then I am on the '<heading_text>' page

    Examples:
      | header_link     | heading_text                                   |
      | Admin dashboard | RM6232 administration dashboard                |
      | Sign out        | Sign in to the RM6232 administration dashboard |

  Scenario Outline: Admin dashboard - <header_link>
    And I should see the following navigation links:
      | Admin dashboard |
      | Sign out        |
    And I click on '<header_link>'
    And I am on the '<heading_text>' page

    Examples:
      | header_link     | heading_text                                   |
      | Admin dashboard | RM6232 administration dashboard                |
      | Sign out        | Sign in to the RM6232 administration dashboard |

  Scenario Outline: Admin page - <header_link>
    When I click on 'Supplier data'
    Then I am on the 'Supplier data' page
    And I should see the following navigation links:
      | Admin dashboard |
      | Sign out        |
    And I click on '<header_link>'
    Then I am on the '<heading_text>' page

    Examples:
      | header_link     | heading_text                                   |
      | Admin dashboard | RM6232 administration dashboard                |
      | Sign out        | Sign in to the RM6232 administration dashboard |
