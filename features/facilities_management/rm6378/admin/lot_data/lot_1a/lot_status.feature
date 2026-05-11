Feature: Facilities Management - Admin - Supplier lot data - Lot 1a - Lot status

  Scenario: Lot status
    Given I sign in as an admin for the 'RM6378' framework in 'Facilities Management'
    And I click on 'Manage supplier data'
    Then I am on the 'Supplier data' page
    And I click on 'View lot data' for 'BEATTY AND SONS'
    Then I am on the 'Supplier lot data' page
    And the caption is 'BEATTY AND SONS'
    And I should see the following details in the summary for the lot 'Lot 1a - Total Facilities Management':
      | Lot status    | Enabled            |
      | Services      | View services      |
      | Jurisdictions | View jurisdictions |
    And I click on 'Change Lot status (Lot 1a - Total Facilities Management)'
    Then I am on the 'Edit lot status' page
    And the caption is 'BEATTY AND SONS'
    And I choose the 'Disabled' radio button
    And I click on 'Save and return'
    Then I am on the 'Supplier lot data' page
    And the caption is 'BEATTY AND SONS'
    And I should see the following details in the summary for the lot 'Lot 1a - Total Facilities Management':
      | Lot status    | Disabled           |
      | Services      | View services      |
      | Jurisdictions | View jurisdictions |
