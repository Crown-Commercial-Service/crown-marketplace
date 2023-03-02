Feature: Saved searches

  Scenario: Navigate to saved searches page - no procurements
    Given I sign in and navigate to my account for 'RM6232'
    And I click on 'View your saved searches'
    Then I am on the 'Saved searches' page
     Then the following content should be displayed on the page:
      | Your saved searches are shown below. Click on the search name to view the details.  |
      | You do not have any saved searches                                                  |

  Scenario: Navigate to saved searches page - some procurements
    Given I sign in and navigate to my account for 'RM6232'
    And I have a procurement with the name 'Procurement number 1'
    And I have a procurement with the name 'Procurement number 2'
    And I have a procurement with the name 'Procurement number 3'
    And I click on 'View your saved searches'
    Then I am on the 'Saved searches' page
    And I should see the following procurements listed:
      | Procurement number 1  |
      | Procurement number 2  |
      | Procurement number 3  |
