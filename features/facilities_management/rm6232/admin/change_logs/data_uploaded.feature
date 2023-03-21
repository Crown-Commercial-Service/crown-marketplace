Feature: Change log for data uploads

  Scenario: Data uploads are logged
    Given I sign in as an admin and navigate to the 'RM6232' dashboard
    And the user 'reiner.braun@attackontitn.pa' has uploaded some data
    And I click on 'Supplier data change log'
    Then I am on the 'Supplier data change log' page
    And I should see 2 logs
    And log number 1 has the user 'reiner.braun@attackontitn.pa'
    And log number 1 has the change type 'Data uploaded'
    And log number 2 has the user 'During a deployment'
    And log number 2 has the change type 'Data uploaded'
    And I click on log number 2
    Then I am on the 'Supplier data upload' page
    And the following content should be displayed on the page:
      | This upload was created via a deployment to the application.    |
      | You can get the data that was used by speaking to a developer.  |
    Then I click on 'Supplier data change log'
    And I am on the 'Supplier data change log' page
    And I click on log number 1
    Then I am on the 'Supplier data upload' page
    And the change was made by 'reiner.braun@attackontitn.pa'
    And I click on 'upload'
    And I am on the 'Upload session' page
    And the upload was done by 'reiner.braun@attackontitn.pa'
