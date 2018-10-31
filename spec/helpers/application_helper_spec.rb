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
        allow(helper).to receive(:content_for).with(:page_title_prefix).and_return(nil)
      end

      it 'returns title stored in locale file' do
        expect(helper.page_title).to eq(t('layouts.application.title'))
      end
    end

    context 'when optional prefix is an empty string' do
      before do
        allow(helper).to receive(:content_for).with(:page_title_prefix).and_return('')
      end

      it 'returns title stored in locale file' do
        expect(helper.page_title).to eq(t('layouts.application.title'))
      end
    end

    context 'when optional prefix contains a newline' do
      before do
        allow(helper).to receive(:content_for).with(:page_title_prefix).and_return("Error\n")
      end

      it 'returns title stored in locale file with prefix' do
        expected_title = 'Error: ' + t('layouts.application.title')
        expect(helper.page_title).to eq(expected_title)
      end
    end

    context 'when optional prefix is set' do
      before do
        allow(helper).to receive(:content_for).with(:page_title_prefix).and_return('Error')
      end

      it 'returns title stored in locale file with prefix' do
        expected_title = 'Error: ' + t('layouts.application.title')
        expect(helper.page_title).to eq(expected_title)
      end
    end
  end
end
