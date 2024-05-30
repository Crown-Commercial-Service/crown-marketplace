import jQuery from 'jquery'
import Rails from '@rails/ujs'
import Turbolinks from 'turbolinks'
import { initAll as initCCS } from './src/ccs'
import { initAll as initGOVUKFrontend } from 'govuk-frontend'

// Initiate @rails/ujs
Rails.start()
Turbolinks.start()

// Initiate jQuery
window.$ = window.jQuery = jQuery

$(document).on('turbolinks:load', () => {
  // Initiate GOV.UK Frontend
  initGOVUKFrontend()

  // Initiate CCS
  initCCS()
})
