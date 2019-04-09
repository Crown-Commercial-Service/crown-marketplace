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
      before(:context) do
        CCS::FM::Supplier.delete_all
      end

      it 'does not create any suppliers' do
        expect do
          described_class.upload_json!(suppliers)
        end.not_to change(CCS::FM::Supplier, :count)
      end
    end

    context 'when supplier does not exist' do
      before(:context) do
        CCS::FM::Supplier.delete_all
      end
      it 'creates record of successful upload' do
        expect do
          described_class.upload_json!(suppliers)
        end.to change(FacilitiesManagement::Upload, :count).by(1)
      end

      it 'creates supplier' do
        expect do
          described_class.upload_json!(suppliers)
        end.to change(CCS::FM::Supplier, :count).by(1)
      end

      it 'assigns ID to supplier' do
        described_class.upload_json!(suppliers)

        supplier = CCS::FM::Supplier.last
        expect(supplier.id).to eq(supplier_id)
      end

      it 'assigns attributes to supplier' do
        described_class.upload_json!(suppliers)

        supplier = CCS::FM::Supplier.last
        expect(supplier.data['supplier_name']).to eq(supplier_name)
      end

      it 'assigns contact-related attributes to supplier' do
        described_class.upload_json!(suppliers)

        supplier = CCS::FM::Supplier.last
        expect(supplier.data['contact_name']).to eq(contact_name)
        expect(supplier.data['contact_email']).to eq(contact_email)
      end
    end

    context 'when suppliers already exist' do
      let!(:first_supplier) { create(:ccs_fm_supplier) }
      let!(:second_supplier) { create(:ccs_fm_supplier) }

      it 'destroys all existing suppliers' do
        described_class.upload_json!(suppliers)

        expect(CCS::FM::Supplier.find_by(supplier_id: first_supplier.supplier_id))
          .to eq(first_supplier)
        expect(CCS::FM::Supplier.find_by(supplier_id: second_supplier.supplier_id))
          .to eq(second_supplier)
      end

      context 'and data for one supplier is invalid' do
        let(:suppliers) do
          [
            {
              'supplier_id' => supplier_id,
              'supplier_name' => '',
              'contact_name' => '',
              'contact_email' => '',
              'contact_phone' => '',
            }
          ]
        end

        it 'does not create record of unsuccessful upload' do
          expect do
            ignoring_exception(ActiveRecord::RecordInvalid) do
              described_class.upload_json!(suppliers)
            end
          end.to change(FacilitiesManagement::Upload, :count).by(1)
        end

        it 'leaves existing data intact' do
          ignoring_exception(ActiveRecord::RecordInvalid) do
            described_class.upload_json!(suppliers)
          end

          expect(CCS::FM::Supplier.find_by(supplier_id: first_supplier.id))
            .to eq(first_supplier)
          expect(CCS::FM::Supplier.find_by(supplier_id: second_supplier.id))
            .to eq(second_supplier)
        end
      end
    end

    context 'when data for one supplier is invalid' do
      let(:suppliers) do
        [
          {
            # 'supplier_id' => SecureRandom.uuid,
            'supplier_name' => supplier_name,
            'contact_name' => contact_name,
            'contact_email' => contact_email,
            'contact_phone' => telephone_number,
          },
          {
            # 'supplier_id' => SecureRandom.uuid,
            'contact_name' => '',
            'contact_phone' => '',
          }
        ]
      end

      it 'raises #<ActiveRecord::NotNullViolation: exception' do
        expect do
          described_class.upload_json!(suppliers)
        end.to raise_error(ActiveRecord::NotNullViolation)
      end

      it 'does not create any suppliers' do
        expect do
          ignoring_exception(ActiveRecord::NotNullViolation) do
            described_class.upload_json!(suppliers)
          end
        end.not_to change(CCS::FM::Supplier, :count)
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

      it 'does not create any suppliers' do
        expect do
          ignoring_exception(ActiveRecord::RecordInvalid) do
            described_class.upload_json!(suppliers)
          end
        end.to change(CCS::FM::Supplier, :count)
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

      it 'does create one supplier' do
        expect do
          ignoring_exception(ActiveRecord::RecordInvalid) do
            described_class.upload_json!(suppliers)
          end
        end.to change(CCS::FM::Supplier, :count).by(1)
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
