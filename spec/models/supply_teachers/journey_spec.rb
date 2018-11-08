require 'rails_helper'

module SupplyTeachers
  RSpec.describe Journey, type: :model do
    before do
      Geocoder::Lookup::Test.add_stub(
        'W1A 1AA', [{ 'coordinates' => [51.5149666, -0.119098] }]
      )
    end

    after do
      Geocoder::Lookup::Test.reset
    end

    context 'when following the school journey' do
      subject(:journey) do
        SupplyTeachers::Journey.new(slug, ActionController::Parameters.new(params))
      end

      context 'when on the Looking For page' do
        let(:slug) { 'looking-for' }

        context 'with no parameters' do
          let(:params) { {} }

          it { is_expected.to have_attributes(current_slug: slug) }
          it { is_expected.to have_attributes(previous_slug: nil) }
          it { is_expected.to have_attributes(next_slug: nil) }
          it { is_expected.to have_attributes(params: {}) }
          it { is_expected.to have_attributes(template: 'looking_for') }
          it { is_expected.not_to be_valid }
        end

        context 'with invalid parameters' do
          let(:params) { { 'looking_for' => 'rubbish' } }

          it { is_expected.to have_attributes(current_slug: slug) }
          it { is_expected.to have_attributes(previous_slug: nil) }
          it { is_expected.to have_attributes(next_slug: nil) }
          it { is_expected.to have_attributes(template: 'looking_for') }
          it { is_expected.not_to be_valid }

          it 'collects the supplied parameters' do
            expect(journey.params).to eq(params)
          end
        end

        context 'with additional parameters' do
          let(:params) { { 'looking_for' => 'worker', 'junk' => 'extraneous' } }

          it 'collects only known parameters' do
            expect(journey.params.keys).to eq(['looking_for'])
          end
        end
      end

      context 'when looking for a worker' do
        let(:slug) { 'looking-for' }
        let(:params) { { 'looking_for' => 'worker' } }

        it { is_expected.to have_attributes(current_slug: slug) }
        it { is_expected.to have_attributes(previous_slug: nil) }
        it { is_expected.to have_attributes(next_slug: 'worker-type') }
        it { is_expected.to be_valid }

        it 'collects the supplied parameters' do
          expect(journey.params).to eq(params)
        end

        context 'when looking for a nominated worker' do
          let(:slug) { 'worker-type' }
          let(:params) { super().merge('worker_type' => 'nominated') }

          it { is_expected.to have_attributes(current_slug: slug) }
          it { is_expected.to have_attributes(previous_slug: 'looking-for') }
          it { is_expected.to have_attributes(next_slug: 'school-postcode') }
          it { is_expected.to be_valid }

          it 'collects the supplied parameters' do
            expect(journey.params).to eq(params)
          end

          context 'when entering a postcode' do
            let(:slug) { 'school-postcode' }
            let(:params) { super().merge('postcode' => 'W1A 1AA') }

            it { is_expected.to have_attributes(current_slug: slug) }
            it { is_expected.to have_attributes(previous_slug: 'worker-type') }
            it { is_expected.to have_attributes(next_slug: 'nominated-worker-results') }
            it { is_expected.to be_valid }

            it 'collects the supplied parameters' do
              expect(journey.params).to eq(params)
            end
          end
        end

        context 'when looking for an agency-supplied worker' do
          let(:slug) { 'worker-type' }
          let(:params) { super().merge('worker_type' => 'agency_supplied') }

          it { is_expected.to have_attributes(current_slug: slug) }
          it { is_expected.to have_attributes(previous_slug: 'looking-for') }
          it { is_expected.to have_attributes(next_slug: 'payroll-provider') }
          it { is_expected.to be_valid }

          it 'collects the supplied parameters' do
            expect(journey.params).to eq(params)
          end

          context 'when putting the worker on the school payroll' do
            let(:slug) { 'payroll-provider' }
            let(:params) { super().merge('payroll_provider' => 'school') }

            it { is_expected.to have_attributes(current_slug: slug) }
            it { is_expected.to have_attributes(previous_slug: 'worker-type') }
            it { is_expected.to have_attributes(next_slug: 'school-postcode') }
            it { is_expected.to be_valid }

            it 'collects the supplied parameters' do
              expect(journey.params).to eq(params)
            end

            context 'when entering a postcode' do
              let(:slug) { 'school-postcode' }
              let(:params) { super().merge('postcode' => 'W1A 1AA') }

              it { is_expected.to have_attributes(current_slug: slug) }
              it { is_expected.to have_attributes(previous_slug: 'payroll-provider') }
              it { is_expected.to have_attributes(next_slug: 'fixed-term-results') }
              it { is_expected.to be_valid }

              it 'collects the supplied parameters' do
                expect(journey.params).to eq(params)
              end
            end
          end

          context 'when putting the worker on an agency payroll' do
            let(:slug) { 'payroll-provider' }
            let(:params) { super().merge('payroll_provider' => 'agency') }

            it { is_expected.to have_attributes(current_slug: slug) }
            it { is_expected.to have_attributes(previous_slug: 'worker-type') }
            it { is_expected.to have_attributes(next_slug: 'agency-payroll') }
            it { is_expected.to be_valid }

            it 'collects the supplied parameters' do
              expect(journey.params).to eq(params)
            end

            context 'when entering the role details' do
              let(:slug) { 'agency-payroll' }
              let(:params) do
                super().merge(
                  'postcode' => 'W1A 1AA',
                  'term' => '0_1',
                  'job_type' => 'qt'
                )
              end

              it { is_expected.to have_attributes(current_slug: slug) }
              it { is_expected.to have_attributes(previous_slug: 'payroll-provider') }
              it { is_expected.to have_attributes(next_slug: 'agency-payroll-results') }
              it { is_expected.to be_valid }

              it 'collects the supplied parameters' do
                expect(journey.params).to eq(params)
              end
            end
          end
        end
      end

      context 'when looking for a managed service provider' do
        let(:slug) { 'looking-for' }
        let(:params) { { 'looking_for' => 'managed_service_provider' } }

        it { is_expected.to have_attributes(current_slug: slug) }
        it { is_expected.to have_attributes(previous_slug: nil) }
        it { is_expected.to have_attributes(next_slug: 'managed-service-provider') }
        it { is_expected.to be_valid }

        it 'collects the supplied parameters' do
          expect(journey.params).to eq(params)
        end

        context 'when looking for a master vendor' do
          let(:slug) { 'managed-service-provider' }
          let(:params) { super().merge('managed_service_provider' => 'master_vendor') }

          it { is_expected.to have_attributes(current_slug: slug) }
          it { is_expected.to have_attributes(previous_slug: 'looking-for') }
          it { is_expected.to have_attributes(next_slug: 'master-vendor-managed-service') }
          it { is_expected.to be_valid }

          it 'collects the supplied parameters' do
            expect(journey.params).to eq(params)
          end
        end

        context 'when looking for a neutral vendor' do
          let(:slug) { 'managed-service-provider' }
          let(:params) { super().merge('managed_service_provider' => 'neutral_vendor') }

          it { is_expected.to have_attributes(current_slug: slug) }
          it { is_expected.to have_attributes(previous_slug: 'looking-for') }
          it { is_expected.to have_attributes(next_slug: 'neutral-vendor-managed-service') }
          it { is_expected.to be_valid }

          it 'collects the supplied parameters' do
            expect(journey.params).to eq(params)
          end
        end
      end
    end
  end
end
