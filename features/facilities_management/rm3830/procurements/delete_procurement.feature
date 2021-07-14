Feature: Delete procurement

  Background: Log in and navigate to my account
    Given I sign in and navigate to my account for 'RM3830'

  Scenario: Delete a procurement in searches
    And I have an empty procurement for entering requirements named 'Search procurement'
    And I click on 'Continue a procurement'
    Then I am on the 'Procurements dashboard' page
    And I choose to delete the procurement named 'Search procurement'
    Then I am on the "Are you sure you want to delete 'Search procurement'?" page
    And I click on 'Confirm delete'
    Then I am on the 'Procurements dashboard' page
    And my procurement 'Search procurement' has successfully been deleted

  Scenario: Delete procurement in draft
    And I have a procurement in DA draft at the 'contract_details' stage named 'In draft procurement'
    And I click on 'Continue a procurement'
    Then I am on the 'Procurements dashboard' page
    And I choose to delete the procurement named 'In draft procurement'
    Then I am on the "Are you sure you want to delete 'In draft procurement'?" page
    And I click on 'Confirm delete'
    Then I am on the 'Procurements dashboard' page
    And my procurement 'In draft procurement' has successfully been deleted
  
  Scenario: I cancel deleting the procurement
    And I have an empty procurement for entering requirements named 'Search procurement'
    And I click on 'Continue a procurement'
    Then I am on the 'Procurements dashboard' page
    And I choose to delete the procurement named 'Search procurement'
    Then I am on the "Are you sure you want to delete 'Search procurement'?" page
    And I click on 'Cancel'
    Then I am on the 'Procurements dashboard' page
    And I click on 'Search procurement'
    And I am on the 'Requirements' page