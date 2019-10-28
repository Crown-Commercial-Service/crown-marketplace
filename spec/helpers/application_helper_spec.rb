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

  describe '#miles_to_meters' do
    it 'returns the distance in miles in meters' do
      miles = 10
      expected = DistanceConverter.miles_to_metres(miles)
      expect(helper.miles_to_metres(miles)).to eq(expected)
    end
  end

  describe '#validation_message' do
    context 'when a classname only is used' do
      it 'an empty hash is returned' do
        validation_message = helper.validation_messages :procurement2
        # puts $stdout, validation_message.class.name
        expect(validation_message.class.name).to eq 'Hash'
        expect(validation_message.empty?).to eq true
      end

      it 'returns a hash' do
        validation_message = helper.validation_messages :procurement
        # puts $stdout, validation_message.class.name
        expect(validation_message.class.name).to eq 'Hash'
        expect(validation_message.empty?).to eq false
      end
    end

    context 'when an attribute is also used' do
      it 'will return an empty hash when the attribute cannot be found' do
        validation_message = helper.validation_messages(:procurement, :blahblah)
        # puts $stdout, validation_message.class.name
        expect(validation_message.class.name).to eq 'Hash'
        expect(validation_message.empty?).to eq true
      end

      it 'will return an empty hash when the attribute has no translations' do
        validation_message = helper.validation_messages(:procurement, :blah)
        # puts $stdout, validation_message.class.name
        expect(validation_message.class.name).to eq 'Hash'
        expect(validation_message.empty?).to eq true
      end

      it 'will return a populated hash when the attribute has translations' do
        validation_message = helper.validation_messages(:procurement, :initial_call_off_period)
        # puts $stdout, validation_message.class.name
        expect(validation_message.class.name).to eq 'Hash'
        expect(validation_message.empty?).to eq false
      end
    end

    context 'when rendering HTML' do
      it 'will list elements' do
        validation_output = helper.display_potential_errors(FacilitiesManagement::Procurement.new, :initial_call_off_period)
        # puts $stdout, validation_output
        expect(validation_output).to include('div')
      end
    end
  end
end
