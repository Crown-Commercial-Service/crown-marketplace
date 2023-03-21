Feature: Service standards

  Background: Navigate to the Service requirements page
    Given I sign in and navigate to my account for 'RM3830'
    And I have a procurement in detailed search named 'Service standard procurement' with the following services:
      | C.5 |
      | G.5 |
      | C.7 |
    And I navigate to the service requirements page

  Scenario: The services have the right details depending on the type of service
    Given I choose to answer the service standard question for 'Lifts, hoists & conveyance systems maintenance'
    Then I am on the page with secondary heading 'Lifts, hoists & conveyance systems maintenance'
    Then the following content should be displayed on the page:
      | Standard A - the general or normal service level            |
      | Standard B - this is the minimum level of service required  |
      | Standard C - a bespoke service level                        |
    Given I click on the 'Return to service requirements' return link
    Then I am on the page with secondary heading 'Service requirements'
    Given I choose to answer the service standard question for 'Cleaning of external areas'
    Then I am on the page with secondary heading 'Cleaning of external areas'
    Then the following content should be displayed on the page:
      | Standard A - the general or normal service level            |
      | Standard B - the highest service level                      |
      | Standard C - a bespoke service level                        |
    Given I click on the 'Return to service requirements' back link
    Then I am on the page with secondary heading 'Service requirements'
    Given I choose to answer the service standard question for 'Internal & external building fabric maintenance'
    Then I am on the page with secondary heading 'Internal & external building fabric maintenance'
    Then the following content should be displayed on the page:
      | Standard A - the general or normal service level                              |
      | Standard B - this is the minimum level of service required                    |
      | Standard C - this level of service will be bespoke and site or area specific  |

  Scenario: The service standard selection saves
    Given I choose to answer the service standard question for 'Lifts, hoists & conveyance systems maintenance'
    Then I am on the page with secondary heading 'Lifts, hoists & conveyance systems maintenance'
    And I select Standard 'A'
    Then I click on 'Save and return'
    Then I am on the page with secondary heading 'Service requirements'
    Then the standard for 'Lifts, hoists & conveyance systems maintenance' is 'A'
    Given I choose to answer the service standard question for 'Cleaning of external areas'
    Then I am on the page with secondary heading 'Cleaning of external areas'
    And I select Standard 'B'
    Then I click on 'Save and return'
    Then I am on the page with secondary heading 'Service requirements'
    Then the standard for 'Cleaning of external areas' is 'B'
    Given I choose to answer the service standard question for 'Internal & external building fabric maintenance'
    Then I am on the page with secondary heading 'Internal & external building fabric maintenance'
    And I select Standard 'C'
    Then I click on 'Save and return'
    Then I am on the page with secondary heading 'Service requirements'
    Then the standard for 'Internal & external building fabric maintenance' is 'C'

  Scenario: Change the service standard selection
    Given I choose to answer the service standard question for 'Cleaning of external areas'
    Then I am on the page with secondary heading 'Cleaning of external areas'
    And I select Standard 'B'
    Then I click on 'Save and return'
    Then I am on the page with secondary heading 'Service requirements'
    Then the standard for 'Cleaning of external areas' is 'B'
    Given I choose to answer the service standard question for 'Cleaning of external areas'
    Then I am on the page with secondary heading 'Cleaning of external areas'
    And I select Standard 'A'
    Then I click on 'Save and return'
    Then I am on the page with secondary heading 'Service requirements'
    Then the standard for 'Cleaning of external areas' is 'A'