Feature: Internal and external area validations

  Background: Internal and external area page
    Given I sign in and navigate to my account for 'RM3830'
    And I have a procurement in detailed search named 'Area procurement' with the following services:
      | C.1 |
      | G.5 |
    And I navigate to the service requirements page
    And I choose to answer the service volume question for 'Mechanical and electrical engineering maintenance'
    Then I am on the Internal and external areas page in service requirements

  Scenario: Areas are empty
  And I enter '' for the building 'GIA'
  And I enter '' for the building 'external area'
  And I click on 'Save and return'
  Then I should see the following error messages:
    | Internal area must be a number between 0 and 999,999,999  |
    | External area must be a number between 0 and 999,999,999  |

  Scenario: Areas are not numbers
    And I enter 'hello' for the building 'GIA'
    And I enter 'hello' for the building 'external area'
    And I click on 'Save and return'
    Then I should see the following error messages:
      | Gross Internal Area (GIA) must be a whole number  |
      | External area must be a whole number              |

  Scenario: Areas are not whole numbers
    And I enter '56.7' for the building 'GIA'
    And I enter '1234.67' for the building 'external area'
    And I click on 'Save and return'
    Then I should see the following error messages:
      | Enter a whole number for the size of internal area of this building |
      | Enter a whole number for the size of external area of this building |

  Scenario: Areas are greater than 999,999,999
    And I enter '1000000000' for the building 'GIA'
    And I enter '1000000000' for the building 'external area'
    And I click on 'Save and return'
    Then I should see the following error messages:
      | Internal area must be a number between 0 and 999,999,999  |
      | External area must be a number between 0 and 999,999,999  |

  Scenario: Areas are both 0
    And I enter '0' for the building 'GIA'
    And I enter '0' for the building 'external area'
    And I click on 'Save and return'
    Then I should see the following error messages:
      | Internal area must be greater than 0, if the external area is 0 |
      | External area must be greater than 0, if the internal area is 0 |

  Scenario: External area cannot be 0
    And I enter '0' for the building 'external area'
    And I click on 'Save and return'
    Then I should see the following error messages:
      | External area must be greater than 0  |

  Scenario: Internal area cannot be 0
    And I enter '0' for the building 'GIA'
    And I click on 'Save and return'
    Then I should see the following error messages:
      | Gross Internal Area (GIA) must be greater than 0  |
