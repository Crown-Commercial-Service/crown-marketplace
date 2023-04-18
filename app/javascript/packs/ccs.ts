import initCheckboxAccordion from '../src/shared/checkboxAccordion'
import initChooseServicesForBuilding from '../src/facilitiesManagement/procurements/chooseServicesForBuilding'
import initContactDetailsInStorage from '../src/facilitiesManagement/contactDetailsInStorage'
import initCookieBanner from '../src/shared/cookieBanner'
import initDetailsLinks from '../src/facilitiesManagement/detailsLinks'
import initFilterTable from '../src/facilitiesManagement/filterTable'
import initFindAddress from '../src/facilitiesManagement/findAddress'
import initGoogleAnalyticsDataLayer from '../src/shared/googleAnalyticsDataLayer'
import initHeader from '../src/shared/header'
import initLimitInputToInteger from '../src/facilitiesManagement/integerInput'
import initManagementReport from '../src/facilitiesManagement/rm3830/admin/managementReport'
import initNumberWithCommas from '../src/facilitiesManagement/numberWithCommas'
import initPasswordStrength from '../src/shared/passwordStrength'
import initResultsToggle from '../src/facilitiesManagement/procurements/resultsToggle'
import initRM3830AdminAdminUpload from '../src/facilitiesManagement/rm3830/admin/adminUploadProgress'
import initSelectRegion from '../src/facilitiesManagement/procurements/selectRegion'
import initStepByStepNav from '../src/shared/stepByStepNav'
import initSupplierDataSnapshot from '../src/facilitiesManagement/rm6232/admin/supplierDataSnapshot'

$(document).on('turbolinks:load', () => {
  // Facilities Management - Procurements TS
  initChooseServicesForBuilding()
  initResultsToggle()
  initSelectRegion()

  // Facilities Management - RM3830 - Admin TS
  initRM3830AdminAdminUpload()
  initManagementReport()

  // Facilities Management - RM6232 - Admin TS
  initSupplierDataSnapshot()

  // Facilities Management TS
  initContactDetailsInStorage()
  initDetailsLinks()
  initFilterTable()
  initFindAddress()
  initLimitInputToInteger()
  initNumberWithCommas()

  // Shared TS
  initCheckboxAccordion()
  initCookieBanner()
  initGoogleAnalyticsDataLayer()
  initHeader()
  initPasswordStrength()
  initStepByStepNav()
})
