@javascript
Feature: Cookie settings

  Background: Go to start page
    Given I go to the facilities management RM6378 start page
    And the cookie banner 'is' visible

  Scenario: Selecting links in the banner - view cookies
    When I click on 'View cookies'
    Then I am on the 'Details about cookies on Crown Marketplace' page
    And the cookie banner 'is' visible

  Scenario: Selecting links in the banner - accept cookies
    When I click on 'Accept analytics cookies'
    Then the cookie banner shows I have 'accepted' the cookies
    And I click on 'Start now'
    Then I am on the 'Sign in to your account' page
    And the cookie banner 'is not' visible
    And the cookies have been saved
    And the 'ga' cookies have been 'accepted'
    And the 'glassbox' cookies have been 'accepted'

  Scenario: Selecting links in the banner - reject cookies
    When I click on 'Reject analytics cookies'
    Then the cookie banner shows I have 'rejected' the cookies
    And I click on 'Start now'
    Then I am on the 'Sign in to your account' page
    And the cookie banner 'is not' visible
    And the cookies have been saved
    And the 'ga' cookies have been 'rejected'
    And the 'glassbox' cookies have been 'rejected'

  Scenario: Changing the cookie settings - enableing the ga cookies only
    When I click on 'Reject analytics cookies'
    Then the cookie banner shows I have 'rejected' the cookies
    And I click on 'Cookie settings'
    Then I am on the 'Cookies on Crown Marketplace' page
    And the cookie banner 'is not' visible
    And the cookies have been saved
    And the 'ga' cookies have been 'rejected'
    And the 'glassbox' cookies have been 'rejected'
    And I choose to 'enable' 'ga' cookies
    And I choose to 'disable' 'glassbox' cookies
    And I click on 'Save changes'
    And the cookies have been saved
    And the 'ga' cookies have been 'accepted'
    And the 'glassbox' cookies have been 'rejected'

  Scenario: Changing the cookie settings - enableing the glassbox cookies only
    When I click on 'Reject analytics cookies'
    Then the cookie banner shows I have 'rejected' the cookies
    And I click on 'Cookie settings'
    Then I am on the 'Cookies on Crown Marketplace' page
    And the cookie banner 'is not' visible
    And the cookies have been saved
    And the 'ga' cookies have been 'rejected'
    And the 'glassbox' cookies have been 'rejected'
    And I choose to 'disable' 'ga' cookies
    And I choose to 'enable' 'glassbox' cookies
    And I click on 'Save changes'
    And the cookies have been saved
    And the 'ga' cookies have been 'rejected'
    And the 'glassbox' cookies have been 'accepted'

  Scenario: Changing the cookie settings - enableing the ga and glassbox cookies
    When I click on 'Reject analytics cookies'
    Then the cookie banner shows I have 'rejected' the cookies
    And I click on 'Cookie settings'
    Then I am on the 'Cookies on Crown Marketplace' page
    And the cookie banner 'is not' visible
    And the cookies have been saved
    And the 'ga' cookies have been 'rejected'
    And the 'glassbox' cookies have been 'rejected'
    And I choose to 'enable' 'ga' cookies
    And I choose to 'enable' 'glassbox' cookies
    And I click on 'Save changes'
    And the cookies have been saved
    And the 'ga' cookies have been 'accepted'
    And the 'glassbox' cookies have been 'accepted'

  Scenario: Changing the cookie settings - disableing the ga and glassbox cookies
    When I click on 'Accept analytics cookies'
    Then the cookie banner shows I have 'accepted' the cookies
    And I click on 'Cookie settings'
    Then I am on the 'Cookies on Crown Marketplace' page
    And the cookie banner 'is not' visible
    And the cookies have been saved
    And the 'ga' cookies have been 'accepted'
    And the 'glassbox' cookies have been 'accepted'
    And I choose to 'disable' 'ga' cookies
    And I choose to 'disable' 'glassbox' cookies
    And I click on 'Save changes'
    And the cookies have been saved
    And the 'ga' cookies have been 'rejected'
    And the 'glassbox' cookies have been 'rejected'
