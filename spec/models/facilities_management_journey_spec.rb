require 'rails_helper'

# rubocop:disable RSpec/NestedGroups
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

    context 'when looking for a supplier under £1.5m' do
      let(:slug) { 'value-band' }
      let(:params) { { 'value_band' => 'under1_5m' } }

      it { is_expected.to have_attributes(current_slug: slug) }
      it { is_expected.to have_attributes(previous_slug: nil) }
      it { is_expected.to have_attributes(next_slug: 'supplier-region') }
      it { is_expected.to be_valid }

      it 'collects the supplied parameters' do
        expect(journey.params).to eq(params)
      end

      context 'when choosing regions' do
        let(:slug) { 'supplier-region' }
        let(:params) { super().merge('region_codes' => %w[UKC1 UKL11]) }

        it { is_expected.to have_attributes(current_slug: slug) }
        it { is_expected.to have_attributes(previous_slug: 'value-band') }
        it { is_expected.to have_attributes(next_slug: 'suppliers') }
        it { is_expected.to be_valid }

        it 'collects the supplied parameters' do
          expect(journey.params).to eq(params)
        end

        context 'when on the results page' do
          let(:slug) { 'suppliers' }

          it { is_expected.to have_attributes(current_slug: slug) }
          it { is_expected.to have_attributes(previous_slug: 'supplier-region') }
          it { is_expected.to be_valid }

          it 'collects the supplied parameters' do
            expect(journey.params).to eq(params)
          end
        end
      end
    end

    context 'when looking for a supplier under £7m' do
      let(:slug) { 'value-band' }
      let(:params) { { 'value_band' => 'under7m' } }

      it { is_expected.to have_attributes(current_slug: slug) }
      it { is_expected.to have_attributes(previous_slug: nil) }
      it { is_expected.to have_attributes(next_slug: 'supplier-region') }
      it { is_expected.to be_valid }

      it 'collects the supplied parameters' do
        expect(journey.params).to eq(params)
      end

      context 'when choosing regions' do
        let(:slug) { 'supplier-region' }
        let(:params) { super().merge('region_codes' => %w[UKC1 UKL11]) }

        it { is_expected.to have_attributes(current_slug: slug) }
        it { is_expected.to have_attributes(previous_slug: 'value-band') }
        it { is_expected.to have_attributes(next_slug: 'suppliers') }
        it { is_expected.to be_valid }

        it 'collects the supplied parameters' do
          expect(journey.params).to eq(params)
        end

        context 'when on the results page' do
          let(:slug) { 'suppliers' }

          it { is_expected.to have_attributes(current_slug: slug) }
          it { is_expected.to have_attributes(previous_slug: 'supplier-region') }
          it { is_expected.to be_valid }

          it 'collects the supplied parameters' do
            expect(journey.params).to eq(params)
          end
        end
      end
    end

    context 'when looking for a supplier under £50m' do
      let(:slug) { 'value-band' }
      let(:params) { { 'value_band' => 'under50m' } }

      it { is_expected.to have_attributes(current_slug: slug) }
      it { is_expected.to have_attributes(previous_slug: nil) }
      it { is_expected.to have_attributes(next_slug: 'suppliers') }
      it { is_expected.to be_valid }

      it 'collects the supplied parameters' do
        expect(journey.params).to eq(params)
      end

      context 'when on the results page' do
        let(:slug) { 'suppliers' }

        it { is_expected.to have_attributes(current_slug: slug) }
        it { is_expected.to have_attributes(previous_slug: 'value-band') }
        it { is_expected.to be_valid }

        it 'collects the supplied parameters' do
          expect(journey.params).to eq(params)
        end
      end
    end

    context 'when looking for a supplier over £50m' do
      let(:slug) { 'value-band' }
      let(:params) { { 'value_band' => 'over50m' } }

      it { is_expected.to have_attributes(current_slug: slug) }
      it { is_expected.to have_attributes(previous_slug: nil) }
      it { is_expected.to have_attributes(next_slug: 'suppliers') }
      it { is_expected.to be_valid }

      it 'collects the supplied parameters' do
        expect(journey.params).to eq(params)
      end

      context 'when on the results page' do
        let(:slug) { 'suppliers' }

        it { is_expected.to have_attributes(current_slug: slug) }
        it { is_expected.to have_attributes(previous_slug: 'value-band') }
        it { is_expected.to be_valid }

        it 'collects the supplied parameters' do
          expect(journey.params).to eq(params)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
