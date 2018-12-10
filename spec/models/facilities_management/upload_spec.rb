require 'rails_helper'

RSpec.describe FacilitiesManagement::Upload, type: :model do
  describe 'create' do
    let(:supplier_name) { Faker::Company.unique.name }
    let(:supplier_id) { SecureRandom.uuid }
    let(:contact_name) { Faker::Name.unique.name }
    let(:contact_email) { Faker::Internet.unique.email }
    let(:telephone_number) { Faker::PhoneNumber.unique.phone_number }

    let(:lots) { [] }

    let(:suppliers) do
      [
        {
          'supplier_name' => supplier_name,
          'supplier_id' => supplier_id,
          'contact_name' => contact_name,
          'contact_email' => contact_email,
          'contact_phone' => telephone_number,
          'lots' => lots
        }
      ]
    end

    context 'when supplier list is empty' do
      let(:suppliers) { [] }

      it 'does not create any suppliers' do
        expect do
          described_class.upload!(suppliers)
        end.not_to change(FacilitiesManagement::Supplier, :count)
      end
    end

    context 'when supplier does not exist' do
      it 'creates supplier' do
        expect do
          described_class.upload!(suppliers)
        end.to change(FacilitiesManagement::Supplier, :count).by(1)
      end

      it 'assigns ID to supplier' do
        described_class.upload!(suppliers)

        supplier = FacilitiesManagement::Supplier.last
        expect(supplier.id).to eq(supplier_id)
      end

      it 'assigns attributes to supplier' do
        described_class.upload!(suppliers)

        supplier = FacilitiesManagement::Supplier.last
        expect(supplier.name).to eq(supplier_name)
      end

      it 'assigns contact-related attributes to supplier' do
        described_class.upload!(suppliers)

        supplier = FacilitiesManagement::Supplier.last
        expect(supplier.contact_name).to eq(contact_name)
        expect(supplier.contact_email).to eq(contact_email)
        expect(supplier.telephone_number).to eq(telephone_number)
      end

      context 'and supplier has lots with regions' do
        let(:lots) do
          [
            {
              'lot_number' => '1a',
              'regions' => %w[UKC1 UKC2]
            },
            {
              'lot_number' => '1b',
              'regions' => %w[UKD1]
            },
          ]
        end

        let(:supplier) { FacilitiesManagement::Supplier.last }

        let(:regional_availabilities) do
          supplier.regional_availabilities.order(:lot_number, :region_code)
        end

        it 'creates regional availabilities associated with supplier' do
          expect do
            described_class.upload!(suppliers)
          end.to change(FacilitiesManagement::RegionalAvailability, :count).by(3)
        end

        it 'assigns attributes to first regional availability' do
          described_class.upload!(suppliers)

          availability = regional_availabilities.first
          expect(availability.lot_number).to eq('1a')
          expect(availability.region_code).to eq('UKC1')
        end

        it 'assigns attributes to second regional availability' do
          described_class.upload!(suppliers)

          availability = regional_availabilities.second
          expect(availability.lot_number).to eq('1a')
          expect(availability.region_code).to eq('UKC2')
        end

        it 'assigns attributes to third regional availability' do
          described_class.upload!(suppliers)

          availability = regional_availabilities.third
          expect(availability.lot_number).to eq('1b')
          expect(availability.region_code).to eq('UKD1')
        end
      end

      context 'and supplier has lots with services' do
        let(:lots) do
          [
            {
              'lot_number' => '1a',
              'services' => %w[A.1 A.2]
            },
            {
              'lot_number' => '1b',
              'services' => %w[A.3]
            },
          ]
        end

        let(:supplier) { FacilitiesManagement::Supplier.last }

        let(:service_offerings) do
          supplier.service_offerings.order(:lot_number, :service_code)
        end

        it 'creates service offerings associated with supplier' do
          expect do
            described_class.upload!(suppliers)
          end.to change(FacilitiesManagement::ServiceOffering, :count).by(3)
        end

        it 'assigns attributes to first service offering' do
          described_class.upload!(suppliers)

          offering = service_offerings.first
          expect(offering.lot_number).to eq('1a')
          expect(offering.service_code).to eq('A.1')
        end

        it 'assigns attributes to second service offering' do
          described_class.upload!(suppliers)

          offering = service_offerings.second
          expect(offering.lot_number).to eq('1a')
          expect(offering.service_code).to eq('A.2')
        end

        it 'assigns attributes to third service offering' do
          described_class.upload!(suppliers)

          offering = service_offerings.third
          expect(offering.lot_number).to eq('1b')
          expect(offering.service_code).to eq('A.3')
        end
      end
    end

    context 'when suppliers already exist' do
      let!(:first_supplier) { create(:facilities_management_supplier) }
      let!(:second_supplier) { create(:facilities_management_supplier) }

      it 'destroys all existing suppliers' do
        described_class.upload!(suppliers)

        expect(FacilitiesManagement::Supplier.find_by(id: first_supplier.id))
          .to be_nil
        expect(FacilitiesManagement::Supplier.find_by(id: second_supplier.id))
          .to be_nil
      end

      context 'and data for one supplier is invalid' do
        let(:suppliers) do
          [
            {
              'supplier_name' => '',
              'contact_name' => '',
              'contact_email' => '',
              'contact_phone' => '',
            }
          ]
        end

        it 'leaves existing data intact' do
          ignoring_exception(ActiveRecord::RecordInvalid) do
            described_class.upload!(suppliers)
          end

          expect(FacilitiesManagement::Supplier.find_by(id: first_supplier.id))
            .to eq(first_supplier)
          expect(FacilitiesManagement::Supplier.find_by(id: second_supplier.id))
            .to eq(second_supplier)
        end
      end
    end

    context 'when data for one supplier is invalid' do
      let(:suppliers) do
        [
          {
            'supplier_name' => supplier_name,
            'contact_name' => contact_name,
            'contact_email' => contact_email,
            'contact_phone' => telephone_number,
          },
          {
            'supplier_name' => '',
            'contact_name' => '',
            'contact_phone' => '',
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
        end.not_to change(FacilitiesManagement::Supplier, :count)
      end
    end

    context 'when data for one lot is invalid' do
      let(:lots) do
        [
          {
            'lot_number' => '1a',
            'regions' => %w[UKC1 UKC2]
          },
          {
            'lot_number' => '',
            'regions' => %w[UKD1]
          },
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
        end.not_to change(FacilitiesManagement::Supplier, :count)
      end
    end

    context 'when data for one region is invalid' do
      let(:lots) do
        [
          {
            'lot_number' => '1a',
            'regions' => %w[UKC1 UKC2]
          },
          {
            'lot_number' => '1b',
            'regions' => ['']
          },
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
        end.not_to change(FacilitiesManagement::Supplier, :count)
      end
    end
  end

  private

  def ignoring_exception(klass)
    yield
  rescue klass
    nil
  end
end
