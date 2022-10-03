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
        expected_title = "Error: #{t('layouts.application.title')}"
        expect(helper.page_title).to eq(expected_title)
      end
    end

    context 'when optional prefix is set' do
      before do
        allow(helper).to receive(:content_for).with(anything).and_return(nil)
        allow(helper).to receive(:content_for).with(:page_title_prefix).and_return('Error')
      end

      it 'returns title stored in locale file with prefix' do
        expected_title = "Error: #{t('layouts.application.title')}"
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
        expected_title = "prefix: page: section: #{t('layouts.application.title')}"
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
        expect(html).to have_css('input[type="hidden"][name="question-1"][value="answer-1"]', visible: :hidden)
      end

      it 'renders hidden field for question 2' do
        expect(html).to have_css('input[type="hidden"][name="question-2"][value="answer-2"]', visible: :hidden)
      end
    end
  end

  describe '#validation_message' do
    context 'when a classname only is used' do
      it 'an empty hash is returned' do
        validation_message = helper.validation_messages :procurement2
        expect(validation_message.class.name).to eq 'Hash'
        expect(validation_message.empty?).to eq true
      end

      it 'returns a hash' do
        proc = FacilitiesManagement::RM3830::Procurement.new

        validation_message = helper.validation_messages proc.class.name.underscore.downcase.to_sym
        expect(validation_message.class.name).to eq 'Hash'
        expect(validation_message.empty?).to eq false
      end
    end

    context 'when an attribute is also used' do
      it 'will return an empty hash when the attribute cannot be found' do
        validation_message = helper.validation_messages(:procurement, :blahblah)
        expect(validation_message.class.name).to eq 'Hash'
        expect(validation_message.empty?).to eq true
      end

      it 'will return an empty hash when the attribute has no translations' do
        validation_message = helper.validation_messages(:procurement, :blah)
        expect(validation_message.class.name).to eq 'Hash'
        expect(validation_message.empty?).to eq true
      end

      it 'will return a populated hash when the attribute has translations' do
        proc = FacilitiesManagement::RM3830::Procurement.new

        validation_message = helper.validation_messages(proc.class.name.underscore.downcase.to_sym, :initial_call_off_period_years)
        expect(validation_message.class.name).to eq 'Hash'
        expect(validation_message.empty?).to eq false
      end
    end

    context 'when rendering HTML' do
      it 'will list elements' do
        validation_output = helper.display_potential_errors(FacilitiesManagement::RM3830::Procurement.new, :initial_call_off_period_years, 'facilities_management_rm3830_procurement_initial_call_off_period')
        expect(validation_output).to include('div')
      end
    end
  end

  describe '#da_eligible?' do
    context 'when the code belongs to a DA eligable service' do
      it 'returns true' do
        expect(helper.da_eligible?('C.1')).to be true
      end
    end

    context 'when the code belongs to a non-DA service' do
      it 'returns false' do
        expect(helper.da_eligible?('C.14')).to be false
      end
    end
  end

  describe '.can_show_new_framework_banner?' do
    before { allow(Marketplace).to receive(:rm6232_live?).and_return(rm6232_live) }

    let(:results) { helper.can_show_new_framework_banner? }

    context 'when rm6232 is live' do
      let(:rm6232_live) { true }

      context 'and the param show_new_framework_banner is present' do
        before { helper.params[:show_new_framework_banner] = 'true' }

        it 'returns true' do
          expect(results).to be true
        end
      end

      context 'and the param show_new_framework_banner is not present' do
        it 'returns true' do
          expect(results).to be true
        end
      end
    end

    context 'when rm6232 is not live' do
      let(:rm6232_live) { false }

      context 'and the param show_new_framework_banner is present' do
        before { helper.params[:show_new_framework_banner] = 'true' }

        it 'returns true' do
          expect(results).to be true
        end
      end

      context 'and the param show_new_framework_banner is not present' do
        it 'returns false' do
          expect(results).to be false
        end
      end
    end
  end

  describe '.cookie_preferences_settings' do
    let(:result) { helper.cookie_preferences_settings }
    let(:default_cookie_settings) do
      {
        'settings_viewed' => false,
        'google_analytics_enabled' => false,
        'glassbox_enabled' => false
      }
    end

    context 'when the cookie has not been set' do
      it 'returns the default settings' do
        expect(result).to eq(default_cookie_settings)
      end
    end

    context 'when the cookie has been set' do
      before { helper.request.cookies['crown_marketplace_cookie_options_v1'] = cookie_settings }

      context 'and it is a hash' do
        let(:expected_cookie_settings) do
          {
            'settings_viewed' => true,
            'google_analytics_enabled' => true,
            'glassbox_enabled' => false
          }
        end
        let(:cookie_settings) { expected_cookie_settings.to_json }

        it 'returns the settings from the cookie' do
          expect(result).to eq(expected_cookie_settings)
        end
      end

      context 'and it is not a hash' do
        let(:cookie_settings) { '123' }

        it 'returns the default settings' do
          expect(result).to eq(default_cookie_settings)
        end
      end
    end
  end
end
