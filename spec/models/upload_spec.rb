require 'rails_helper'

RSpec.describe Upload, type: :model do
  describe 'create' do
    let(:branch_name) { 'Head Office' }
    let(:branch_town) { 'Guildford' }
    let(:supplier_name) { "Acme Teachers Ltd #{Time.current}" }
    let(:supplier_id) { SecureRandom.uuid }
    let(:postcode) { rand(36**8).to_s(36) }
    let(:phone_number) { '020 7946 0000' }
    let(:accreditation_body) { 'REC' }

    let(:branches) do
      [
        {
          'branch_name' => branch_name,
          'town' => branch_town,
          'postcode' => postcode,
          'lat' => 50.0,
          'lon' => 1.0,
          'telephone' => phone_number,
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
          'supplier_name' => supplier_name,
          'supplier_id' => supplier_id,
          'accreditation' => accreditation_body,
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
        expect(supplier.id).to eq(supplier_id)
      end

      it 'assigns attributes to supplier' do
        described_class.create!(suppliers)

        supplier = Supplier.last
        expect(supplier.name).to eq(supplier_name)
        expect(supplier.accreditation_body).to eq(accreditation_body)
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
        expect(branch.name).to eq(branch_name)
      end

      it 'assigns address-related attributes to the branch' do
        described_class.create!(suppliers)

        supplier = Supplier.last
        branch = supplier.branches.first
        expect(branch.town).to eq(branch_town)
        expect(branch.postcode).to eq(postcode)
      end

      it 'assigns geography-related attributes to the branch' do
        described_class.create!(suppliers)

        supplier = Supplier.last
        branch = supplier.branches.first
        expect(branch.location.latitude).to be_within(1e-6).of(50.0)
        expect(branch.location.longitude).to be_within(1e-6).of(1.0)
      end

      it 'assigns contact-related attributes to the branch' do
        described_class.create!(suppliers)

        supplier = Supplier.last
        branch = supplier.branches.first
        expect(branch.telephone_number).to eq(phone_number)
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
        let(:another_postcode) { rand(36**8).to_s(36) }
        let(:branches) do
          [
            {
              'postcode' => postcode,
              'lat' => 50.0,
              'lon' => 1.0,
              'telephone' => phone_number,
              'contacts' => [
                {
                  'name' => 'Colin Warden',
                  'email' => 'colin.warden@example.com'
                }
              ]
            },
            {
              'postcode' => another_postcode,
              'lat' => 50.0,
              'lon' => 1.0,
              'telephone' => phone_number,
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
          expect(branches.map(&:postcode)).to include(postcode, another_postcode)
        end
      end
    end

    context 'when suppliers already exist' do
      before do
        allow(UKPostcode).to receive(:parse).and_return(valid_postcode)
      end

      let!(:first_supplier) { create(:supplier) }
      let!(:second_supplier) { create(:supplier) }

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
        end.not_to change(Supplier, :count)
      end
    end

    context 'when data for one suppliers branch is invalid' do
      let(:suppliers) do
        [
          {
            'supplier_name' => supplier_name,
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
