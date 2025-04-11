import { PostProcessResultFunction, RemoteFormHandler } from '../shared/remoteForm'

const updateErrorMessages: PostProcessResultFunction = (responseJSON) => {
  if (responseJSON.error_message_html) {
    if ($('#email-error').length === 0) {
      $('#email-form-group').addClass('govuk-form-group--error')
      $('#email-hint').after(responseJSON.error_message_html)
    }
  } else {
    if ($('#email-error').length > 0) {
      $('#email-form-group').removeClass('govuk-form-group--error')
      $('#email-error').remove()
    }
  }
}

const initUserSearch = () => {
  new RemoteFormHandler('users-table', updateErrorMessages).init()
}

export default initUserSearch
