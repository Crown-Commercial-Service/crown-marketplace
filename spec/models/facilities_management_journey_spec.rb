require 'rails_helper'

RSpec.describe FacilitiesManagementJourney, type: :model do
  context 'when following the facilities management journey' do
    subject(:journey) do
      FacilitiesManagementJourney.new(slug, ActionController::Parameters.new(params))
    end

    context 'when on the value band page' do
      let(:slug) { 'value-band' }

      context 'with no parameters' do
        let(:params) { {} }

        it { is_expected.to have_attributes(current_slug: slug) }
        it { is_expected.to have_attributes(previous_slug: nil) }
        it { is_expected.to have_attributes(next_slug: nil) }
        it { is_expected.to have_attributes(params: {}) }
        it { is_expected.to have_attributes(template: 'value_band') }
        it { is_expected.not_to be_valid }
      end

      context 'with invalid parameters' do
        let(:params) { { 'value_band' => 'rubbish' } }

        it { is_expected.to have_attributes(current_slug: slug) }
        it { is_expected.to have_attributes(previous_slug: nil) }
        it { is_expected.to have_attributes(next_slug: nil) }
        it { is_expected.to have_attributes(template: 'value_band') }
        it { is_expected.not_to be_valid }
      end

      context 'with additional parameters' do
        let(:params) { { 'value_band' => 'under7m', 'junk' => 'extraneous' } }

        it 'collects only known parameters' do
          expect(journey.params.keys).to eq(['value_band'])
        end
      end
    end
  end
end
