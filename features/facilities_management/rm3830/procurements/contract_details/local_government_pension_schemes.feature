Feature: Local government pension scheme

  Background: Navigate to the Local government pension scheme question
    Given I sign in and navigate to my account for 'RM3830'
    And I have a procurement in DA draft at the 'contract_details' stage named 'LGPS procurement'
    When I navigate to the procurement 'LGPS procurement'
    Then I am on the 'Contract details' page
    And I answer the 'Local Government Pension Scheme' contract detail question
    Then I am on the 'Local Government Pension Scheme' page

  Scenario: When no is selected
    Given I select 'No' for the LGPS question
    And I click on 'Save and continue'
    Then I am on the 'Contract details' page
    And my answer to the 'Local Government Pension Scheme' contract detail question is 'Not applicable'

  Scenario: When yes is selected
    Given I select 'Yes' for the LGPS question
    And I click on 'Save and continue'
    Then I am on the 'Pension funds' page
    And I enter the name 'Pension 1' and '43' percent for pension number 1
    When I click on 'Save and return'
    Then I am on the 'Contract details' page
    And the following pensions are listed:
      | Pension 1, 43.0%  |

  @javascript
  Scenario: I can add and remove pension funds
    Given I select 'Yes' for the LGPS question
    And I click on 'Save and continue'
    Then I am on the 'Pension funds' page
    And I add 4 pension funds
    Then there are 5 pension fund rows
    And the add pension fund button has text 'Add another pension fund (94 remaining)'
    And I enter the name 'Pension 5' and '3.14' percent for pension number 1
    And I enter the name 'Pension 4' and '15.9' percent for pension number 2
    And I enter the name 'Pension 3' and '2.65' percent for pension number 3
    And I enter the name 'Pension 2' and '3.58' percent for pension number 4
    And I enter the name 'Pension 1' and '9.79' percent for pension number 5
    When I click on 'Save and return'
    Then I am on the 'Contract details' page
    And the following pensions are listed:
      | Pension 5, 3.14%  |
      | Pension 4, 15.9%  |
      | Pension 3, 2.65%  |
      | Pension 2, 3.58%  |
      | Pension 1, 9.79%  |
    And I open the 'Pension scheme details' details
    And I click on 'Add or remove pension funds'
    Then I am on the 'Pension funds' page
    And I remove pension fund number 2
    And I remove pension fund number 3
    Then there are 3 pension fund rows
    And the add pension fund button has text 'Add another pension fund (96 remaining)'
    When I click on 'Save and return'
    Then I am on the 'Contract details' page
    And the following pensions are listed:
      | Pension 5, 3.14%  |
      | Pension 3, 2.65%  |
      | Pension 1, 9.79%  |
    And I answer the 'Local Government Pension Scheme' contract detail question
    Then I am on the 'Local Government Pension Scheme' page
    And I click on 'Save and continue'
    Then I am on the 'Pension funds' page
    And I add 1 pension fund
    And I remove pension fund number 4
    And I remove pension fund number 3
    Then there are 2 pension fund rows
    And the add pension fund button has text 'Add another pension fund (97 remaining)'
    And I enter the name 'Pension 1' and '8.78' percent for pension number 2
    Then I click on 'Save and return'
    Then I am on the 'Contract details' page
    And the following pensions are listed:
      | Pension 5, 3.14%  |
      | Pension 1, 8.78%  |

  Scenario: Return links work
    When I click on the 'Return to contract details' return link
    Then I am on the 'Contract details' page
    Then I answer the 'Local Government Pension Scheme' contract detail question
    And I am on the 'Local Government Pension Scheme' page
    Then I select 'Yes' for the LGPS question
    And I click on 'Save and continue'
    Then I am on the 'Pension funds' page
    Given I click on the 'Return to Local Government Pension Scheme' back link
    And I am on the 'Local Government Pension Scheme' page
    And I click on the 'Return to contract details' back link
    Then I am on the 'Contract details' page
    And my answer to the 'Local Government Pension Scheme' contract detail question is 'Answer question'
    Then I answer the 'Local Government Pension Scheme' contract detail question
    And I am on the 'Local Government Pension Scheme' page
    Then I select 'Yes' for the LGPS question
    And I click on 'Save and continue'
    Then I am on the 'Pension funds' page
    When I click on the 'Return to contract details' return link
    Then I am on the 'Contract details' page
