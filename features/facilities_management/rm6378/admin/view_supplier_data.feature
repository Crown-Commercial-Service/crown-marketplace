Feature: Facilities Management - Admin - View supplier data pages

  Background: Navigate to supplier data page
    Given I sign in as an admin for the 'RM6378' framework in 'Facilities Management'
    And I click on 'Manage supplier data'
    Then I am on the 'Supplier data' page

  @javascript
  Scenario: Supplier data page
    Then I should see the following suppliers on the page:
      | BEATTY AND SONS                  |
      | BEIER INC                        |
      | BERNIER-MILLER                   |
      | BOSCO-KOSS                       |
      | BUCKRIDGE-HALVORSON              |
      | CRONIN-AUFDERHAR                 |
      | DENESIK, REMPEL AND ORN          |
      | DONNELLY-KOHLER                  |
      | DOOLEY-HILPERT                   |
      | FEENEY AND SONS                  |
      | FEEST AND SONS                   |
      | GLEASON INC                      |
      | GOLDNER-GUSIKOWSKI               |
      | GREEN-LEUSCHKE                   |
      | HALVORSON, HARVEY AND BLICK      |
      | HAYES, MURRAY AND PAGAC          |
      | HOWELL LLC                       |
      | KEMMER AND SONS                  |
      | KEMMER GROUP                     |
      | KIRLIN, RUTHERFORD AND MONAHAN   |
      | KRAJCIK AND SONS                 |
      | KREIGER, BORER AND ORN           |
      | LABADIE-RYAN                     |
      | LABADIE-WATERS                   |
      | LANG, O'REILLY AND FARRELL       |
      | LEANNON, HILLL AND MILLS         |
      | LEUSCHKE INC                     |
      | LOWE, SIMONIS AND POUROS         |
      | MAYER INC                        |
      | MOEN, WILL AND BEIER             |
      | MORISSETTE-ERDMAN                |
      | PFANNERSTILL-DICKENS             |
      | PFEFFER, HOWELL AND REINGER      |
      | PURDY, SENGER AND SCHROEDER      |
      | RENNER-RENNER                    |
      | ROWE INC                         |
      | SCHAEFER, DOOLEY AND BAYER       |
      | SCHMELER, MAYER AND BOGISICH     |
      | SCHMITT, STANTON AND MAGGIO      |
      | SCHMITT-BARTELL                  |
      | SMITHAM, WUCKERT AND RYAN        |
      | STAMM, BOTSFORD AND VANDERVORT   |
      | THIEL INC                        |
      | THOMPSON, SCHROEDER AND JACOBSON |
      | TORP, KEEBLER AND THIEL          |
      | TORPHY AND SONS                  |
      | TOWNE-BOGISICH                   |
      | TOWNE-SCHOWALTER                 |
      | UPTON-KING                       |
      | WEST-PARKER                      |
      | WYMAN, ABSHIRE AND POWLOWSKI     |
    And I enter "en" for the supplier search
    Then I should see the following suppliers on the page:
      | DENESIK, REMPEL AND ORN     |
      | FEENEY AND SONS             |
      | GREEN-LEUSCHKE              |
      | MOEN, WILL AND BEIER        |
      | PFANNERSTILL-DICKENS        |
      | PURDY, SENGER AND SCHROEDER |
      | RENNER-RENNER               |
    And I enter "" for the supplier search
    Then I should see the following suppliers on the page:
      | BEATTY AND SONS                  |
      | BEIER INC                        |
      | BERNIER-MILLER                   |
      | BOSCO-KOSS                       |
      | BUCKRIDGE-HALVORSON              |
      | CRONIN-AUFDERHAR                 |
      | DENESIK, REMPEL AND ORN          |
      | DONNELLY-KOHLER                  |
      | DOOLEY-HILPERT                   |
      | FEENEY AND SONS                  |
      | FEEST AND SONS                   |
      | GLEASON INC                      |
      | GOLDNER-GUSIKOWSKI               |
      | GREEN-LEUSCHKE                   |
      | HALVORSON, HARVEY AND BLICK      |
      | HAYES, MURRAY AND PAGAC          |
      | HOWELL LLC                       |
      | KEMMER AND SONS                  |
      | KEMMER GROUP                     |
      | KIRLIN, RUTHERFORD AND MONAHAN   |
      | KRAJCIK AND SONS                 |
      | KREIGER, BORER AND ORN           |
      | LABADIE-RYAN                     |
      | LABADIE-WATERS                   |
      | LANG, O'REILLY AND FARRELL       |
      | LEANNON, HILLL AND MILLS         |
      | LEUSCHKE INC                     |
      | LOWE, SIMONIS AND POUROS         |
      | MAYER INC                        |
      | MOEN, WILL AND BEIER             |
      | MORISSETTE-ERDMAN                |
      | PFANNERSTILL-DICKENS             |
      | PFEFFER, HOWELL AND REINGER      |
      | PURDY, SENGER AND SCHROEDER      |
      | RENNER-RENNER                    |
      | ROWE INC                         |
      | SCHAEFER, DOOLEY AND BAYER       |
      | SCHMELER, MAYER AND BOGISICH     |
      | SCHMITT, STANTON AND MAGGIO      |
      | SCHMITT-BARTELL                  |
      | SMITHAM, WUCKERT AND RYAN        |
      | STAMM, BOTSFORD AND VANDERVORT   |
      | THIEL INC                        |
      | THOMPSON, SCHROEDER AND JACOBSON |
      | TORP, KEEBLER AND THIEL          |
      | TORPHY AND SONS                  |
      | TOWNE-BOGISICH                   |
      | TOWNE-SCHOWALTER                 |
      | UPTON-KING                       |
      | WEST-PARKER                      |
      | WYMAN, ABSHIRE AND POWLOWSKI     |

  Scenario Outline: Supplier details page
    And I click on 'View details' for '<supplier_name>'
    Then I am on the 'Supplier details' page
    And the caption is '<supplier_name>'
    And I should see the following details in the 'Supplier information' summary:
      | Name        | <supplier_name> |
      | DUNS Number | <duns_number>   |
      | Is an SME?  | <sme>           |

    Examples:
      | supplier_name    | duns_number | sme |
      | CRONIN-AUFDERHAR | 327002007   | Yes |
      | GLEASON INC      | 544162007   | Yes |
      | SCHMITT-BARTELL  | 135258164   | No  |

  Scenario: Lot status
    And I click on 'View lot data' for 'HAYES, MURRAY AND PAGAC'
    Then I am on the 'Supplier lot data' page
    And the caption is 'HAYES, MURRAY AND PAGAC'
    And I should see the following details in the summary for the lot 'Lot 1a - Total Facilities Management':
      | Lot status    | Enabled            |
      | Services      | View services      |
      | Jurisdictions | View jurisdictions |
    And I should see the following details in the summary for the lot 'Lot 1b - Total Facilities Management':
      | Lot status | Not on lot |
    And I should see the following details in the summary for the lot 'Lot 1c - Total Facilities Management':
      | Lot status | Not on lot |
    And I should see the following details in the summary for the lot 'Lot 2a - Hard Facilities Management':
      | Lot status    | Enabled            |
      | Services      | View services      |
      | Jurisdictions | View jurisdictions |
    And I should see the following details in the summary for the lot 'Lot 2b - Hard Facilities Management':
      | Lot status | Not on lot |
    And I should see the following details in the summary for the lot 'Lot 3a - Soft Facilities Management':
      | Lot status    | Enabled            |
      | Services      | View services      |
      | Jurisdictions | View jurisdictions |
    And I should see the following details in the summary for the lot 'Lot 3b - Soft Facilities Management':
      | Lot status | Not on lot |
    And I should see the following details in the summary for the lot 'Lot 4a - Total Security Services':
      | Lot status    | Enabled            |
      | Services      | View services      |
      | Jurisdictions | View jurisdictions |
    And I should see the following details in the summary for the lot 'Lot 4b - Security Officer Services':
      | Lot status    | Enabled            |
      | Services      | View services      |
      | Jurisdictions | View jurisdictions |
    And I should see the following details in the summary for the lot 'Lot 4c - Electronic security systems and services':
      | Lot status | Not on lot |
    And I should see the following details in the summary for the lot 'Lot 4d - Security advisory and assessment services':
      | Lot status | Not on lot |
