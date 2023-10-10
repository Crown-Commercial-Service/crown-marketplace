// Initiate GOV.UK Frontend
import { initAll } from 'govuk-frontend'

$(document).on('turbolinks:load', () => {
  initAll()
})
