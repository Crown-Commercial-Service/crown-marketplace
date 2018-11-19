require 'rails_helper'

RSpec.describe ManagementConsultancy::Upload, type: :model do
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
          described_class.create!(suppliers)
        end.not_to change(ManagementConsultancy::Supplier, :count)
      end
    end

    context 'when supplier does not exist' do
      it 'creates supplier' do
        expect do
          described_class.create!(suppliers)
        end.to change(ManagementConsultancy::Supplier, :count).by(1)
      end

      it 'assigns ID to supplier' do
        described_class.create!(suppliers)

        supplier = ManagementConsultancy::Supplier.last
        expect(supplier.id).to eq(supplier_id)
      end

      it 'assigns attributes to supplier' do
        described_class.create!(suppliers)

        supplier = ManagementConsultancy::Supplier.last
        expect(supplier.name).to eq(supplier_name)
      end

      it 'assigns contact-related attributes to supplier' do
        described_class.create!(suppliers)

        supplier = ManagementConsultancy::Supplier.last
        expect(supplier.contact_name).to eq(contact_name)
        expect(supplier.contact_email).to eq(contact_email)
        expect(supplier.telephone_number).to eq(telephone_number)
      end

      context 'and supplier has lots with regions' do
        let(:lots) do
          [
            {
              'lot_number' => '1',
              'regions' => { 'UKC1' => 'provided', 'UKC2' => 'provided_if_expenses' }
            },
            {
              'lot_number' => '2',
              'regions' => { 'UKD1' => 'provided' }
            },
          ]
        end

        let(:supplier) { ManagementConsultancy::Supplier.last }

        let(:regional_availabilities) do
          supplier.regional_availabilities.order(:lot_number, :region_code)
        end

        it 'creates regional availabilities associated with supplier' do
          expect do
            described_class.create!(suppliers)
          end.to change(ManagementConsultancy::RegionalAvailability, :count).by(3)
        end

        it 'assigns attributes to first regional availability' do
          described_class.create!(suppliers)

          availability = regional_availabilities.first
          expect(availability.lot_number).to eq('1')
          expect(availability.region_code).to eq('UKC1')
        end

        it 'assigns attributes to second regional availability' do
          described_class.create!(suppliers)

          availability = regional_availabilities.second
          expect(availability.lot_number).to eq('1')
          expect(availability.region_code).to eq('UKC2')
        end

        it 'assigns attributes to third regional availability' do
          described_class.create!(suppliers)

          availability = regional_availabilities.third
          expect(availability.lot_number).to eq('2')
          expect(availability.region_code).to eq('UKD1')
        end
      end

      context 'and supplier has lots with services' do
        let(:lots) do
          [
            {
              'lot_number' => '1',
              'services' => %w[1.1 1.2]
            },
            {
              'lot_number' => '2',
              'services' => %w[2.1]
            },
          ]
        end

        let(:supplier) { ManagementConsultancy::Supplier.last }

        let(:service_offerings) do
          supplier.service_offerings.order(:lot_number, :service_code)
        end

        it 'creates service offerings associated with supplier' do
          expect do
            described_class.create!(suppliers)
          end.to change(ManagementConsultancy::ServiceOffering, :count).by(3)
        end

        it 'assigns attributes to first service offering' do
          described_class.create!(suppliers)

          offering = service_offerings.first
          expect(offering.lot_number).to eq('1')
          expect(offering.service_code).to eq('1.1')
        end

        it 'assigns attributes to second service offering' do
          described_class.create!(suppliers)

          offering = service_offerings.second
          expect(offering.lot_number).to eq('1')
          expect(offering.service_code).to eq('1.2')
        end

        it 'assigns attributes to third service offering' do
          described_class.create!(suppliers)

          offering = service_offerings.third
          expect(offering.lot_number).to eq('2')
          expect(offering.service_code).to eq('2.1')
        end
      end
    end

    context 'when suppliers already exist' do
      let!(:first_supplier) { create(:management_consultancy_supplier) }
      let!(:second_supplier) { create(:management_consultancy_supplier) }

      it 'destroys all existing suppliers' do
        described_class.create!(suppliers)

        expect(ManagementConsultancy::Supplier.find_by(id: first_supplier.id))
          .to be_nil
        expect(ManagementConsultancy::Supplier.find_by(id: second_supplier.id))
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

        it 'leaves existing data intact' do
          ignoring_exception(ActiveRecord::RecordInvalid) do
            described_class.create!(suppliers)
          end

          expect(ManagementConsultancy::Supplier.find_by(id: first_supplier.id))
            .to eq(first_supplier)
          expect(ManagementConsultancy::Supplier.find_by(id: second_supplier.id))
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
          described_class.create!(suppliers)
        end.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'does not create any suppliers' do
        expect do
          ignoring_exception(ActiveRecord::RecordInvalid) do
            described_class.create!(suppliers)
          end
        end.not_to change(ManagementConsultancy::Supplier, :count)
      end
    end

    context 'when data for one lot is invalid' do
      let(:lots) do
        [
          {
            'lot_number' => '1',
            'services' => %w[1.1 1.2]
          },
          {
            'lot_number' => '',
            'services' => %w[2.1]
          },
        ]
      end

      it 'raises ActiveRecord::RecordInvalid exception' do
        expect do
          described_class.create!(suppliers)
        end.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'does not create any suppliers' do
        expect do
          ignoring_exception(ActiveRecord::RecordInvalid) do
            described_class.create!(suppliers)
          end
        end.not_to change(ManagementConsultancy::Supplier, :count)
      end
    end

    context 'when data for one service is invalid' do
      let(:lots) do
        [
          {
            'lot_number' => '1',
            'services' => %w[1.1 1.2]
          },
          {
            'lot_number' => '2',
            'services' => ['']
          },
        ]
      end

      it 'raises ActiveRecord::RecordInvalid exception' do
        expect do
          described_class.create!(suppliers)
        end.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'does not create any suppliers' do
        expect do
          ignoring_exception(ActiveRecord::RecordInvalid) do
            described_class.create!(suppliers)
          end
        end.not_to change(ManagementConsultancy::Supplier, :count)
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
