@pipeline @javascript
Feature: User procurements - index page

  Background: Admin signs in and navigates to the user procurements page
    Given I sign in as an admin and navigate to the 'RM6232' dashboard
    And I have a procurement with the name 'Procurement number 1'
    And I have a procurement with the name 'Procurement number 2'
    And I have a procurement with the name 'Procurement number 3'
    And I have a procurement with the name 'Procurement number 4'
    And I have a procurement with the name 'Procurement number 5'
    And I have a procurement with the name 'Procurement number 6'
    And I have a procurement with the name 'Procurement number 7'
    And I have a procurement with the name 'Procurement number 8'
    And I have a procurement with the name 'Procurement number 9'
    And I have a procurement with the name 'Procurement number 10'
    And I click on 'User procurements'
    Then I am on the 'User procurements' page

  Scenario: User procurements search
    And I should see the following user procurements listed:
      | Procurement number 10 |
      | Procurement number 9  |
      | Procurement number 8  |
      | Procurement number 7  |
      | Procurement number 6  |
      | Procurement number 5  |
      | Procurement number 4  |
      | Procurement number 3  |
      | Procurement number 2  |
      | Procurement number 1  |
    Then I enter "Procurement number 1" for the procurement search
    And I should see the following user procurements listed:
      | Procurement number 10 |
      | Procurement number 1  |
    Then I enter "a random string" for the procurement search
    And the following content should be displayed on the page:
      | There are no procurements that match your search  |
    Then I enter "" for the procurement search
    And I should see the following user procurements listed:
      | Procurement number 10 |
      | Procurement number 9  |
      | Procurement number 8  |
      | Procurement number 7  |
      | Procurement number 6  |
      | Procurement number 5  |
      | Procurement number 4  |
      | Procurement number 3  |
      | Procurement number 2  |
      | Procurement number 1  |

  Scenario: Return links work user procurements page
    Given I click on 'Home'
    Then I am on the 'RM6232 administration dashboard' page