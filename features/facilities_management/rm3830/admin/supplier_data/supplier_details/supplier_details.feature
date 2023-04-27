Feature: Supplier details

  Background: Navigate to the additional supplier information section
    Given I sign in as an admin and navigate to the 'RM3830' dashboard
    And I click on 'Supplier details'
    Then I am on the 'Supplier details' page
    And I click on 'Ullrich, Ratke and Botsford'
    Then I am on the 'Supplier details' page

  Scenario Outline: Supplier details breadcrumbs
    Given I click on '<text>'
    Then I am on the '<page>' page

    Examples:
      | text              | page                            |
      | Home              | RM3830 administration dashboard |
      | Supplier details  | Supplier details                |
