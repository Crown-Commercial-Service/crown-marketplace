Feature: Facilities Management - Admin - Supplier lot data - Lot 4d - Lot status

  Scenario: Lot status
    Given I sign in as an admin for the 'RM6378' framework in 'Facilities Management'
    And I click on 'Manage supplier data'
    Then I am on the 'Supplier data' page
    And I click on 'View lot data' for 'TOWNE-BOGISICH'
    Then I am on the 'Supplier lot data' page
    And the caption is 'TOWNE-BOGISICH'
    And I should see the following details in the summary for the lot 'Lot 4d - Security advisory and assessment services':
      | Lot status    | Enabled            |
      | Services      | View services      |
      | Jurisdictions | View jurisdictions |
    And I click on 'Change Lot status (Lot 4d - Security advisory and assessment services)'
    Then I am on the 'Edit lot status' page
    And the caption is 'TOWNE-BOGISICH'
    And I choose the 'Disabled' radio button
    And I click on 'Save and return'
    Then I am on the 'Supplier lot data' page
    And the caption is 'TOWNE-BOGISICH'
    And I should see the following details in the summary for the lot 'Lot 4d - Security advisory and assessment services':
      | Lot status    | Disabled           |
      | Services      | View services      |
      | Jurisdictions | View jurisdictions |
