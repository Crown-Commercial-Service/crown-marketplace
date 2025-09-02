Feature: Supplier framework data

  Background: Navigate to the services and prices page
    Given I sign in as an admin and navigate to the 'RM3830' dashboard
    And I click on 'Supplier framework data'
    Then I am on the 'Supplier framework data' page
    Given I show all sections

  Scenario: Return to admin dashboard
    Given I click on 'Home'
    Then I am on the 'RM3830 administration dashboard' page

  Scenario Outline: Return links for the service pages
    And select 'Services' for sublot '<lot>' for '<supplier>'
    Then I am on the '<page>' page
    Given I click on '<text>'
    Then I am on the 'Supplier framework data' page

    Examples:
      | lot | supplier            | page                                       | text                              |
      | 1a  | Cartwright and Sons | Sub-lot 1a services, prices, and variances | Supplier framework data           |
      | 1a  | Cartwright and Sons | Sub-lot 1a services, prices, and variances | Return to supplier framework data |
      | 1b  | Graham-Farrell      | Sub-lot 1b services                        | Supplier framework data           |
      | 1b  | Graham-Farrell      | Sub-lot 1b services                        | Return to supplier framework data |
      | 1c  | Smitham-Brown       | Sub-lot 1c services                        | Supplier framework data           |
      | 1c  | Smitham-Brown       | Sub-lot 1c services                        | Return to supplier framework data |

  Scenario Outline: Return links for the region pages
    And select 'Regions' for sublot '<lot>' for '<supplier>'
    Then I am on the '<page>' page
    Given I click on '<text>'
    Then I am on the 'Supplier framework data' page

    Examples:
      | lot | supplier            | page               | text                              |
      | 1a  | Cartwright and Sons | Sub-lot 1a regions | Supplier framework data           |
      | 1a  | Cartwright and Sons | Sub-lot 1a regions | Return to supplier framework data |
      | 1b  | Graham-Farrell      | Sub-lot 1b regions | Supplier framework data           |
      | 1b  | Graham-Farrell      | Sub-lot 1b regions | Return to supplier framework data |
      | 1c  | Smitham-Brown       | Sub-lot 1c regions | Supplier framework data           |
      | 1c  | Smitham-Brown       | Sub-lot 1c regions | Return to supplier framework data |
