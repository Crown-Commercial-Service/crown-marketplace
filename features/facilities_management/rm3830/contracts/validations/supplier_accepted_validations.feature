Feature: Supplier accepeted - validations

  Background: The contract I sent has been accepted
    Given I sign in and navigate to my account for 'RM3830'
    And I have a contract that has been 'accepted' called 'Accepted contract'
    And I click on 'Continue a procurement'
    Then I navigate to the contract 'Accepted contract' in 'Sent offers'
    Then I click on 'Confirm if contract signed or not'
    And I am on the 'Confirmation of signed contract' page

  Scenario: Nothing is selected
    And I click on 'Save and continue'
    Then I should see the following error messages:
      | Select one option |

  Scenario: Reason for not signing is blank
    And I select 'No' for the confirmation of signed contract
    And I click on 'Save and continue'
    Then I should see the following error messages:
      | Enter a reason why this contract will not be signed |
  
  Scenario Outline: Contract dates invalid
    And I select 'Yes' for the confirmation of signed contract
    And I enter '<contract_start_date>' as the contract start date
    And I enter '<contract_end_date>' as the contract end date
    And I click on 'Save and continue'
    Then I should see the following error messages:
      | <error_message> |
    
    Examples:
        | contract_start_date | contract_end_date | error_message                                               |
        |  / / /              | 21/06/2021        | Enter contract start date                                   |
        | 21/06/2021          |  / / /            | Enter contract end date                                     |
        | 31/06/2021          | 21/06/2021        | Enter a valid start date                                    |
        | 21/06/2021          | 31/06/2021        | Enter a valid end date                                      |
        | ab/cd/efgh          | 21/06/2021        | Enter a valid start date                                    |
        | 21/06/2021          | ij/kl/mnop        | Enter a valid end date                                      |
        | 21/06/2021          | 21/06/2020        | The contract end date must be after the contract start date |
        | 31/05/202           | 21/06/2021        | The contract start date must be on or after 1 June 2020     |