Feature: Facilities Management - Admin - Supplier lot data - 4d - View services

  Scenario: Services
    Given I sign in as an admin for the 'RM6378' framework in 'Facilities Management'
    And I click on 'Manage supplier data'
    Then I am on the 'Supplier data' page
    And I click on 'View lot data' for 'TOWNE-BOGISICH'
    Then I am on the 'Supplier lot data' page
    And the caption is 'TOWNE-BOGISICH'
    And I click on 'View services' for the lot 'Lot 4d - Security advisory and assessment services'
    Then I am on the 'Lot 4d - Security advisory and assessment services' page
    And the caption is 'TOWNE-BOGISICH'
    And the supplier should be assigned to the 'services' in 'Security Advisory Services' as follows:
      | Security Advisory Services |
    And the supplier should be assigned to the 'services' in 'Security and Risk Assessments' as follows:
      | Security Assessments |
    And the supplier should be assigned to the 'services' in 'Security Awareness / Training' as follows:
      | Security Awareness / Training |
