import initAllowListSearch from './crownMarketplace/allowListSearch'
import initCheckboxAccordion from './shared/checkboxAccordion'
import initChooseServicesForBuilding from './facilitiesManagement/procurements/chooseServicesForBuilding'
import initContactDetailsInStorage from './facilitiesManagement/contactDetailsInStorage'
import initCookieBanner from './shared/cookieBanner'
import initDetailsLinks from './facilitiesManagement/detailsLinks'
import initFilterTable from './facilitiesManagement/filterTable'
import initFindAddress from './facilitiesManagement/findAddress'
import initGoogleAnalyticsDataLayer from './shared/googleAnalyticsDataLayer'
import initLimitInputToInteger from './facilitiesManagement/integerInput'
import initManagementReport from './facilitiesManagement/rm3830/admin/managementReport'
import initNumberWithCommas from './facilitiesManagement/numberWithCommas'
import initSelectRegion from './facilitiesManagement/procurements/selectRegion'
import initStepByStepNav from './shared/stepByStepNav'
import initSupplierDataSnapshot from './facilitiesManagement/rm6232/admin/supplierDataSnapshot'
import initUserSearch from './crownMarketplace/userSearch'
import initAdminUpload from './shared/adminUpload'
import initReportProgress from './shared/reportProgress'

const initAll = () => {
  // Facilities Management - Procurements TS
  initChooseServicesForBuilding()
  initSelectRegion()

  // Facilities Management - RM3830 - Admin TS
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

  // Crown Marketplace
  initAllowListSearch()
  initUserSearch()

  // Shared TS
  initAdminUpload()
  initReportProgress()
  initCheckboxAccordion()
  initCookieBanner()
  initGoogleAnalyticsDataLayer()
  initStepByStepNav()
}

export { initAll }
