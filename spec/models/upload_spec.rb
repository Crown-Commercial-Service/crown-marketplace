require 'rails_helper'

RSpec.describe Upload, type: :model do
  describe 'create' do
    let(:branch_name) { 'Head Office' }
    let(:branch_town) { 'Guildford' }
    let(:supplier_name) { Faker::Company.unique.name }
    let(:supplier_id) { SecureRandom.uuid }
    let(:postcode) { Faker::Address.unique.postcode }
    let(:phone_number) { Faker::PhoneNumber.unique.phone_number }
    let(:latitude) { Faker::Address.unique.latitude }
    let(:longitude) { Faker::Address.unique.longitude }
    let(:contact_name) { Faker::Name.unique.name }
    let(:contact_email) { Faker::Internet.unique.email }

    let(:pricing) { [] }

    let(:branches) do
      [
        {
          'branch_name' => branch_name,
          'town' => branch_town,
          'postcode' => postcode,
          'lat' => latitude,
          'lon' => longitude,
          'telephone' => phone_number,
          'contacts' => [
            {
              'name' => contact_name,
              'email' => contact_email,
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
          'branches' => branches,
          'pricing' => pricing
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
        expect(branch.location.latitude).to be_within(1e-6).of(latitude)
        expect(branch.location.longitude).to be_within(1e-6).of(longitude)
      end

      it 'assigns contact-related attributes to the branch' do
        described_class.create!(suppliers)

        supplier = Supplier.last
        branch = supplier.branches.first
        expect(branch.telephone_number).to eq(phone_number)
        expect(branch.contact_name).to eq(contact_name)
        expect(branch.contact_email).to eq(contact_email)
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
        let(:another_postcode) { Faker::Address.unique.postcode }
        let(:branches) do
          [
            {
              'postcode' => postcode,
              'lat' => latitude,
              'lon' => longitude,
              'telephone' => phone_number,
              'contacts' => [
                {
                  'name' => contact_name,
                  'email' => contact_email,
                }
              ]
            },
            {
              'postcode' => another_postcode,
              'lat' => latitude,
              'lon' => longitude,
              'telephone' => phone_number,
              'contacts' => [
                {
                  'name' => contact_name,
                  'email' => contact_email,
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

      context 'and supplier has pricing information' do
        let(:pricing) do
          [
            {
              'job_type' => 'nominated',
              'line_no' => 1,
              'fee' => 0.35
            },
            {
              'job_type' => 'qt',
              'line_no' => 2,
              'fee' => 0.40
            }
          ]
        end

        it 'only adds nominated worker rates to supplier' do
          described_class.create!(suppliers)

          supplier = Supplier.last
          expect(supplier.rates.length).to eq(1)
          rate = supplier.rates.first
          expect(rate.job_type).to eq('nominated')
          expect(rate.mark_up).to eq(0.35)
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
            'branches' => [{ 'postcode' => postcode }]
          },
          {
            'supplier_name' => Faker::Company.unique.name,
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
