require 'rails_helper'

RSpec.describe Upload, type: :model do
  describe 'create' do
    let(:unique_supplier_name) { "Acme Teachers Ltd #{Time.current}" }
    let(:unique_supplier_id) { SecureRandom.uuid }
    let(:unique_postcode) { rand(36**8).to_s(36) }

    let(:branches) do
      [
        {
          'postcode' => unique_postcode,
          'contacts' => [
            {
              'name' => 'Joe Bloggs',
              'email' => 'joe.bloggs@example.com',
            }
          ]
        }
      ]
    end

    let(:suppliers) do
      [
        {
          'supplier_name' => unique_supplier_name,
          'supplier_id' => unique_supplier_id,
          'branches' => branches
        }
      ]
    end

    let(:valid_postcode) { instance_double(UKPostcode::GeographicPostcode, valid?: true) }

    context 'when supplier list is empty' do
      let(:suppliers) { [] }

      it 'does not create any suppliers' do
        expect do
          described_class.create!(suppliers)
        end.not_to change(Supplier, :count)
      end
    end

    context 'when supplier does not exist' do
      before do
        allow(UKPostcode).to receive(:parse).and_return(valid_postcode)
      end

      it 'creates supplier' do
        expect do
          described_class.create!(suppliers)
        end.to change(Supplier, :count).by(1)
      end

      it 'assigns ID to supplier' do
        described_class.create!(suppliers)

        supplier = Supplier.last
        expect(supplier.id).to eq(unique_supplier_id)
      end

      it 'assigns name to supplier' do
        described_class.create!(suppliers)

        supplier = Supplier.last
        expect(supplier.name).to eq(unique_supplier_name)
      end

      it 'creates a branch associated with supplier' do
        expect do
          described_class.create!(suppliers)
        end.to change(Branch, :count).by(1)
      end

      it 'assigns attributes to the branch' do
        described_class.create!(suppliers)

        supplier = Supplier.last
        branch = supplier.branches.first
        expect(branch.postcode).to eq(unique_postcode)
        expect(branch.contact_name).to eq('Joe Bloggs')
        expect(branch.contact_email).to eq('joe.bloggs@example.com')
      end

      context 'and supplier has no branches' do
        let(:branches) { [] }

        it 'creates a supplier anyway' do
          expect do
            described_class.create!(suppliers)
          end.to change(Supplier, :count).by(1)
        end
      end

      context 'and supplier has multiple branches' do
        let(:another_unique_postcode) { rand(36**8).to_s(36) }
        let(:branches) do
          [
            {
              'postcode' => unique_postcode,
              'contacts' => [
                {
                  'name' => 'Colin Warden',
                  'email' => 'colin.warden@example.com'
                }
              ]
            },
            {
              'postcode' => another_unique_postcode,
              'contacts' => [
                {
                  'name' => 'Colin Warden',
                  'email' => 'colin.warden@example.com'
                }
              ]
            }
          ]
        end

        it 'creates two branches associated with supplier' do
          expect do
            described_class.create!(suppliers)
          end.to change(Branch, :count).by(2)
        end

        it 'assigns attributes to the branches' do
          described_class.create!(suppliers)

          supplier = Supplier.last
          branches = supplier.branches
          expect(branches.map(&:postcode)).to include(unique_postcode, another_unique_postcode)
        end
      end
    end

    context 'when suppliers already exist' do
      before do
        allow(UKPostcode).to receive(:parse).and_return(valid_postcode)
      end

      let!(:first_supplier) do
        Supplier.create!(id: SecureRandom.uuid, name: 'first-supplier')
      end

      let!(:second_supplier) do
        Supplier.create!(id: SecureRandom.uuid, name: 'second-supplier')
      end

      it 'destroys all existing suppliers' do
        described_class.create!(suppliers)

        expect(Supplier.find_by(id: first_supplier.id)).to be_nil
        expect(Supplier.find_by(id: second_supplier.id)).to be_nil
      end

      context 'and data for one supplier is invalid' do
        let(:suppliers) do
          [
            {
              'supplier_name' => '',
            }
          ]
        end

        it 'leaves existing data intact' do
          ignoring_exception(ActiveRecord::RecordInvalid) do
            described_class.create!(suppliers)
          end

          expect(Supplier.find_by(id: first_supplier.id)).to eq(first_supplier)
          expect(Supplier.find_by(id: second_supplier.id)).to eq(second_supplier)
        end
      end
    end

    context 'when data for one supplier is invalid' do
      let(:suppliers) do
        [
          {
            'supplier_name' => unique_supplier_name,
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
        end.not_to change(Supplier, :count)
      end
    end

    context 'when data for one suppliers branch is invalid' do
      let(:suppliers) do
        [
          {
            'supplier_name' => unique_supplier_name,
            'branches' => [{ 'postcode' => 'SW1AA 1AA' }]
          },
          {
            'supplier_name' => 'Another name',
            'branches' => [{ 'postcode' => 'NOT A POSTCODE' }]
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
        end.not_to change(Supplier, :count)
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
