module Pages
  class DaDraft < SitePrism::Page
    section 'Payment method', 'tbody > tr:nth-of-type(2)' do
      element :answer_question, 'a'
    end

    section 'Invoicing contact details', 'tbody > tr:nth-of-type(2)' do
      element :answer_question, 'a'
    end

    section 'Authorised representative details', 'tbody > tr:nth-of-type(3)' do
      element :answer_question, 'a'
    end

    section 'Notices contact details', 'tbody > tr:nth-of-type(4)' do
      element :answer_question, 'a'
    end

    section 'Security policy', 'tbody > tr:nth-of-type(5)' do
      element :answer_question, 'a'
    end

    section 'Local Government Pension Scheme', 'tbody > tr:nth-of-type(6)' do
      element :answer_question, 'a'
    end

    section 'Governing law', 'tbody > tr:nth-of-type(7)' do
      element :answer_question, 'a'
    end
  end
end
