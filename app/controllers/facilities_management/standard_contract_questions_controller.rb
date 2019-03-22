class FacilitiesManagement::StandardContractQuestionsController < ApplicationController
  require_permission :facilities_management, only: :standard_contract_questions
  def standard_contract_questions
    @inline_error_summary_title = 'There was a problem'
    @inline_error_summary_body_href = '#'
    @inline_summary_error_text = 'TODO add text here'
  end
end
