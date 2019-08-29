require 'rails_helper'

RSpec.describe LegalServices::Upload, type: :model do
  describe 'create' do
    let(:supplier_name) { Faker::Company.unique.name }
    let(:supplier_id) { SecureRandom.uuid }
    let(:contact_email) { Faker::Internet.unique.email }
    let(:telephone_number) { Faker::PhoneNumber.unique.phone_number }

    let(:lots) { [] }
    let(:lot_1_services) { [] }

    let(:suppliers) do
      [
        {
          'name' => supplier_name,
          'supplier_id' => supplier_id,
          'email' => contact_email,
          'phone_number' => telephone_number,
          'lots' => lots,
          'lot_1_services' => lot_1_services,
        }
      ]
    end

    context 'when supplier list is empty' do
      let(:suppliers) { [] }

      it 'does not create any suppliers' do
        expect do
          described_class.upload!(suppliers)
        end.not_to change(LegalServices::Supplier, :count)
      end
    end

    context 'when supplier does not exist' do
      it 'creates record of successful upload' do
        expect do
          described_class.upload!(suppliers)
        end.to change(LegalServices::Upload, :count).by(1)
      end

      it 'creates supplier' do
        expect do
          described_class.upload!(suppliers)
        end.to change(LegalServices::Supplier, :count).by(1)
      end

      it 'assigns ID to supplier' do
        described_class.upload!(suppliers)

        supplier = LegalServices::Supplier.last
        expect(supplier.id).to eq(supplier_id)
      end

      it 'assigns attributes to supplier' do
        described_class.upload!(suppliers)

        supplier = LegalServices::Supplier.last
        expect(supplier.name).to eq(supplier_name)
      end

      it 'assigns contact-related attributes to supplier' do
        described_class.upload!(suppliers)

        supplier = LegalServices::Supplier.last
        expect(supplier.email).to eq(contact_email)
        expect(supplier.phone_number).to eq(telephone_number)
      end

      context 'and supplier is offering lot 1 services in regions' do
        let(:lot_1_services) do
          [
            {
              'service_code' => 'WPSLS.1.1',
              'region_code' => 'UKC'
            },
            {
              'service_code' => 'WPSLS.1.2',
              'region_code' => 'UKD'
            },
            {
              'service_code' => 'WPSLS.1.1',
              'region_code' => 'UKD'
            },
          ]
        end

        let(:supplier) { LegalServices::Supplier.last }

        let(:regional_availabilities) do
          supplier.regional_availabilities.order(:region_code)
        end

        it 'creates regional availabilities associated with supplier' do
          expect do
            described_class.upload!(suppliers)
          end.to change(LegalServices::RegionalAvailability, :count).by(3)
        end

        it 'assigns attributes to first regional availability' do
          described_class.upload!(suppliers)

          availability = regional_availabilities.first
          expect(availability.region_code).to eq('UKC')
        end

        it 'assigns attributes to second regional availability' do
          described_class.upload!(suppliers)

          availability = regional_availabilities.second
          expect(availability.region_code).to eq('UKD')
        end
      end

      context 'and supplier has lots with services' do
        let(:lots) do
          [
            {
              'lot_number' => '2a',
              'services' => %w[WPSLS.2a.1 WPSLS.2a.2]
            },
            {
              'lot_number' => '3',
              'services' => %w[WPSLS.3.1]
            },
          ]
        end

        let(:supplier) { LegalServices::Supplier.last }

        let(:service_offerings) do
          supplier.service_offerings.order(:service_code)
        end

        it 'creates service offerings associated with supplier' do
          expect do
            described_class.upload!(suppliers)
          end.to change(LegalServices::ServiceOffering, :count).by(3)
        end

        it 'assigns attributes to first service offering' do
          described_class.upload!(suppliers)

          offering = service_offerings.first
          expect(offering.service_code).to eq('WPSLS.2a.1')
        end

        it 'assigns attributes to second service offering' do
          described_class.upload!(suppliers)

          offering = service_offerings.second
          expect(offering.service_code).to eq('WPSLS.2a.2')
        end

        it 'assigns attributes to third service offering' do
          described_class.upload!(suppliers)

          offering = service_offerings.third
          expect(offering.service_code).to eq('WPSLS.3.1')
        end
      end
    end

    context 'when suppliers already exist' do
      let!(:first_supplier) { create(:legal_services_supplier) }
      let!(:second_supplier) { create(:legal_services_supplier) }

      it 'destroys all existing suppliers' do
        described_class.upload!(suppliers)

        expect(LegalServices::Supplier.find_by(id: first_supplier.id))
          .to be_nil
        expect(LegalServices::Supplier.find_by(id: second_supplier.id))
          .to be_nil
      end

      context 'and data for one supplier is invalid' do
        let(:suppliers) do
          [
            {
              'supplier_name' => ''
            }
          ]
        end

        it 'does not create record of unsuccessful upload' do
          expect do
            ignoring_exception(ActiveRecord::RecordInvalid) do
              described_class.upload!(suppliers)
            end
          end.to change(LegalServices::Upload, :count).by(0)
        end

        it 'leaves existing data intact' do
          ignoring_exception(ActiveRecord::RecordInvalid) do
            described_class.upload!(suppliers)
          end

          expect(LegalServices::Supplier.find_by(id: first_supplier.id))
            .to eq(first_supplier)
          expect(LegalServices::Supplier.find_by(id: second_supplier.id))
            .to eq(second_supplier)
        end
      end
    end

    context 'when data for one supplier is invalid' do
      let(:suppliers) do
        [
          {
            'supplier_name' => supplier_name,
          },
          {
            'supplier_name' => '',
          }
        ]
      end

      it 'raises ActiveRecord::RecordInvalid exception' do
        expect do
          described_class.upload!(suppliers)
        end.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'does not create any suppliers' do
        expect do
          ignoring_exception(ActiveRecord::RecordInvalid) do
            described_class.upload!(suppliers)
          end
        end.not_to change(LegalServices::Supplier, :count)
      end
    end

    context 'when data for one service is invalid' do
      let(:lots) do
        [
          {
            'lot_number' => '2a',
            'services' => %w[WPSLS.2a.1 WPSLS.2a.2]
          },
          {
            'lot_number' => '2b',
            'services' => %w[invalid]
          }
        ]
      end

      it 'raises ActiveRecord::RecordInvalid exception' do
        expect do
          described_class.upload!(suppliers)
        end.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'does not create any suppliers' do
        expect do
          ignoring_exception(ActiveRecord::RecordInvalid) do
            described_class.upload!(suppliers)
          end
        end.not_to change(LegalServices::Supplier, :count)
      end
    end
  end

  private

  # rubocop:disable Naming/UncommunicativeMethodParamName
  def ignoring_exception(e)
    yield
  rescue e
    nil
  end
  # rubocop:enable Naming/UncommunicativeMethodParamName
end
