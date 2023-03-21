Feature: Service rates - Framework expired

  Scenario Outline: The framework rates page inputs are disabled
    Given the 'RM3830' framework has expired
    And I sign in as an admin and navigate to the 'RM3830' dashboard
    And I click on '<rates_page>'
    Then I am on the '<rates_page>' page
    And I should see the following warning text:
      | The RM3830 has expired, you cannot update these rates. |
    And all the text inputs are disabled
    And the submit button is disabled
  
  Examples:
    | rates_page                |
    | Average framework rates   |
    | Call-off benchmark rates  |
