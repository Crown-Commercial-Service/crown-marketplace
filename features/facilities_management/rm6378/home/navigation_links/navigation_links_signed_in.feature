Feature: Navigation links when signed in

  Background: I navigate to my account page
    Given I sign in and navigate to my account for 'RM6378'

  Scenario: Start page
    When I go to the facilities management RM6378 start page
    And I should see the following navigation links:
      | Sign out |

  Scenario Outline: Not permitted page
    And I go to the 'buyer' not permitted page for 'RM6378'
    And I should see the following navigation links:
      | My account |
      | Sign out   |
    And I click on '<link_text>'
    And I am on the '<page_title>' page

    Examples:
      | link_text  | page_title              |
      | My account | Your account            |
      | Sign out   | Sign in to your account |

  Scenario Outline: Cookies policy
    When I click on 'Cookie policy'
    Then I am on the 'Details about cookies on Crown Marketplace' page
    And I should see the following navigation links:
      | My account |
      | Sign out   |
    And I click on '<link_text>'
    And I am on the '<page_title>' page

    Examples:
      | link_text  | page_title              |
      | My account | Your account            |
      | Sign out   | Sign in to your account |

  Scenario Outline: Cookies settings
    When I click on 'Cookie settings'
    Then I am on the 'Cookies on Crown Marketplace' page
    And I should see the following navigation links:
      | My account |
      | Sign out   |
    And I click on '<link_text>'
    And I am on the '<page_title>' page

    Examples:
      | link_text  | page_title              |
      | My account | Your account            |
      | Sign out   | Sign in to your account |

  Scenario Outline: Accessibility statement
    When I click on 'Accessibility statement'
    Then I am on the 'Facilities Management (FM) Accessibility statement' page
    And I should see the following navigation links:
      | My account |
      | Sign out   |
    And I click on '<link_text>'
    And I am on the '<page_title>' page

    Examples:
      | link_text  | page_title              |
      | My account | Your account            |
      | Sign out   | Sign in to your account |

  Scenario Outline: Home page - Sign out
    And I should see the following navigation links:
      | My account |
      | Sign out   |
    And I click on '<link_text>'
    And I am on the '<page_title>' page

    Examples:
      | link_text  | page_title              |
      | My account | Your account            |
      | Sign out   | Sign in to your account |

  Scenario Outline: Buyer details
    Then I click on 'Manage my details'
    Then I am on the 'Your details' page
    And I should see the following navigation links:
      | My account |
      | Sign out   |
    And I click on '<link_text>'
    And I am on the '<page_title>' page

    Examples:
      | link_text  | page_title              |
      | My account | Your account            |
      | Sign out   | Sign in to your account |

  Scenario Outline: Buyer details - Add address
    Then I click on 'Manage my details'
    Then I am on the 'Your details' page
    And I click on 'Change (Personal details)'
    Then I am on the 'Manage your personal details' page
    And I should see the following navigation links:
      | My account |
      | Sign out   |
    And I click on '<link_text>'
    And I am on the '<page_title>' page

    Examples:
      | link_text  | page_title              |
      | My account | Your account            |
      | Sign out   | Sign in to your account |
