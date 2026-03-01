Feature: Service specification

  Scenario: Service specification
    Given I sign in and navigate to my account for 'RM6378'
    And I click on 'Search for suppliers'
    Then I am on the 'Services' page
    Given I click on the service specification for '<service_name>'
    Then I am on the '<page_title>' page
    And the page sub title is 'Service specification'
    And The service name and code is '<service_name_and_code>'
    And there '<option>' generic requirements

    Examples:
      | service_name                                          | page_title                                                   | service_name_and_code                                      | option  |
      | Mechanical and Electrical Engineering Maintenance     | Work Package C - Maintenance Services                        | C1 - Mechanical and Electrical Engineering Maintenance     | are     |
      | Outside Catering                                      | Work Package F - Catering Services                           | F7 - Outside Catering                                      | are     |
      | CAFM system                                           | Work Package M - Computer Aided Facilities Management (CAFM) | M2 - Hard / Soft FM CAFM Requirements                      | are not |
      | Video Surveillance Systems (VSS) and Alarm Monitoring | Work Package O - Security Officer Services                   | O2 - Video Surveillance Systems (VSS) and Alarm Monitoring | are     |
      | Security Assessments                                  | Work Package T - Security and Risk Assessments               | T1 - Security Assessments                                  | are not |
