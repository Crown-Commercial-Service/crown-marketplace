Feature: Buildings used in a procurement are missing a region

  Background: Sign in and navigate to the page
    Given I sign in and navigate to my account for 'RM3830'
    And I have a completed procurement for entering requirements named 'My missing regions procurement' with buildings missing regions
    When I navigate to the procurement 'My missing regions procurement'
    Then I am on the 'Review your buildings' page

  Scenario: Can complete missing regions for buildings
    Then there are 3 buildings missing a region
    And I select region for 'Test building 1'
    Then I am on the "Confirm your building's region" page
    And I select 'Bedfordshire and Hertfordshire' for the missing region
    And I click on 'Save and return'
    Then I am on the 'Review your buildings' page
    Then there are 2 buildings missing a region
    And I select region for 'Test building 2'
    Then I am on the "Confirm your building's region" page
    And I select 'Aberdeen and Aberdeenshire' for the missing region
    And I click on 'Save and return'
    Then I am on the 'Review your buildings' page
    Then there is 1 building missing a region
    And I select region for 'Test building 3'
    Then I am on the "Confirm your building's region" page
    And I select 'Shropshire and Staffordshire' for the missing region
    And I click on 'Save and return'
    Then I am on the 'Requirements' page
    And everything is completed

  Scenario: Return links work
    Given I select region for 'Test building 1'
    Then I am on the "Confirm your building's region" page
    And I click on the 'Return to review your buildings' return link
    Then I am on the 'Review your buildings' page
    Then I am on the 'Review your buildings' page
    Given I click on the 'Return to procurements dashboard' return link
    Then I am on the 'Procurements dashboard' page
    And I click on 'My missing regions procurement'
    Then I am on the 'Review your buildings' page
    Given I click on the 'Return to procurements dashboard' back link
    Then I am on the 'Procurements dashboard' page
