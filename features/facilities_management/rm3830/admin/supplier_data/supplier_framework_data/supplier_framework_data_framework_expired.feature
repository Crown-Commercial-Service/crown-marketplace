Feature: Supplier framework data - Framework expired

  Background: Navigate to the services and prices page
    Given the 'RM3830' framework has expired
    And I sign in as an admin and navigate to the 'RM3830' dashboard
    And I click on 'Supplier framework data'
    Then I am on the 'Supplier framework data' page
    Given I show all sections

  Scenario Outline: Supplier service data inputs are disabled
    And select 'Services' for sublot '<lot>' for '<supplier>'
    Then I am on the '<page>' page
    And I should see the following warning text:
      | The RM3830 has expired, you cannot update the supplier's services. |
    And there are no text inputs
    And there are no checkbox inputs
    And there is no submit button

    Examples:
      | lot | supplier            | page                                       |
      | 1a  | Cartwright and Sons | Sub-lot 1a services, prices, and variances |
      | 1b  | Graham-Farrell      | Sub-lot 1b services                        |
      | 1c  | Smitham-Brown       | Sub-lot 1c services                        |

  Scenario Outline: Supplier region data inputs are disabled
    And select 'Regions' for sublot '<lot>' for '<supplier>'
    Then I am on the 'Sub-lot <lot> regions' page
    And I should see the following warning text:
      | The RM3830 has expired, you cannot update the supplier's regions. |
    And there are no checkbox inputs
    And there is no submit button

    Examples:
      | lot | supplier            |
      | 1a  | Cartwright and Sons |
      | 1b  | Graham-Farrell      |
      | 1c  | Smitham-Brown       |
