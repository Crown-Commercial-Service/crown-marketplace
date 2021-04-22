Then('I answer the question for {string} on contract details') do |contract_detail|
  da_draft_page.send(contract_detail).answer_question.click
end
