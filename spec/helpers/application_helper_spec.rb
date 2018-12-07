require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#page_title' do
    context 'when there is no prefix' do
      it 'returns title stored in locale file' do
        expect(helper.page_title).to eq(t('layouts.application.title'))
      end
    end

    context 'when optional prefix is nil' do
      before do
        allow(helper).to receive(:content_for).with(anything).and_return(nil)
        allow(helper).to receive(:content_for).with(:page_title_prefix).and_return(nil)
      end

      it 'returns title stored in locale file' do
        expect(helper.page_title).to eq(t('layouts.application.title'))
      end
    end

    context 'when optional prefix is an empty string' do
      before do
        allow(helper).to receive(:content_for).with(anything).and_return(nil)
        allow(helper).to receive(:content_for).with(:page_title_prefix).and_return('')
      end

      it 'returns title stored in locale file' do
        expect(helper.page_title).to eq(t('layouts.application.title'))
      end
    end

    context 'when optional prefix contains a newline' do
      before do
        allow(helper).to receive(:content_for).with(anything).and_return(nil)
        allow(helper).to receive(:content_for).with(:page_title_prefix).and_return("Error\n")
      end

      it 'returns title stored in locale file with prefix' do
        expected_title = 'Error: ' + t('layouts.application.title')
        expect(helper.page_title).to eq(expected_title)
      end
    end

    context 'when optional prefix is set' do
      before do
        allow(helper).to receive(:content_for).with(anything).and_return(nil)
        allow(helper).to receive(:content_for).with(:page_title_prefix).and_return('Error')
      end

      it 'returns title stored in locale file with prefix' do
        expected_title = 'Error: ' + t('layouts.application.title')
        expect(helper.page_title).to eq(expected_title)
      end
    end

    context 'when page_title and page_section are set' do
      before do
        allow(helper).to receive(:content_for).with(:page_title).and_return('page')
        allow(helper).to receive(:content_for).with(:page_section).and_return('section')
        allow(helper).to receive(:content_for).with(:page_title_prefix).and_return('prefix')
      end

      it 'returns fields joined by semi-colons' do
        expected_title = 'prefix: page: section: ' + t('layouts.application.title')
        expect(helper.page_title).to eq(expected_title)
      end
    end
  end

  describe '#hidden_fields_for_previous_steps_and_responses' do
    context 'when there are multiple previous questions and answers' do
      let(:questions_and_answers) do
        {
          'question-1' => 'answer-1',
          'question-2' => 'answer-2'
        }
      end
      let(:journey) { instance_double('Journey', previous_questions_and_answers: questions_and_answers) }
      let(:html) { helper.hidden_fields_for_previous_steps_and_responses(journey) }

      it 'renders hidden field for question 1' do
        expect(html).to have_css('input[type="hidden"][name="question-1"][value="answer-1"]', visible: false)
      end

      it 'renders hidden field for question 2' do
        expect(html).to have_css('input[type="hidden"][name="question-2"][value="answer-2"]', visible: false)
      end
    end
  end
end
