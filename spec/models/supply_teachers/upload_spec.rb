require 'rails_helper'

RSpec.describe SupplyTeachers::Upload, type: :model do
  describe 'create' do
    let(:branch_name) { 'Head Office' }
    let(:branch_town) { 'Guildford' }
    let(:supplier_name) { Faker::Company.unique.name }
    let(:supplier_id) { SecureRandom.uuid }
    let(:postcode) { Faker::Address.unique.postcode }
    let(:region) { 'South East England' }
    let(:address_1) { Faker::Address.street_address }
    let(:address_2) { Faker::Address.secondary_address }
    let(:county) { 'Surrey' }
    let(:phone_number) { Faker::PhoneNumber.unique.phone_number }
    let(:latitude) { Faker::Address.unique.latitude }
    let(:longitude) { Faker::Address.unique.longitude }
    let(:contact_name) { Faker::Name.unique.name }
    let(:contact_email) { Faker::Internet.unique.email }

    let(:pricing) { [] }
    let(:master_vendor_pricing) { [] }
    let(:neutral_vendor_pricing) { [] }

    let(:branches) do
      [
        {
          'branch_name' => branch_name,
          'region' => region,
          'address_1' => address_1,
          'address_2' => address_2,
          'town' => branch_town,
          'county' => county,
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
          'pricing' => pricing,
          'master_vendor_pricing' => master_vendor_pricing,
          'neutral_vendor_pricing' => neutral_vendor_pricing,
          'master_vendor_contact' => {
            'name' => 'Mr. Joelle Littel',
            'telephone' => '0800 966090',
            'email' => 'shawnna@ohara.biz'
          },
          'neutral_vendor_contact' => {
            'name' => 'Ms. Retta Stehr',
            'telephone' => '01677 32220',
            'email' => 'tyree@hoppe.co'
          }
        }
      ]
    end

    let(:valid_postcode) { instance_double(UKPostcode::GeographicPostcode, valid?: true) }

    context 'when supplier list is empty' do
      let(:suppliers) { [] }

      it 'does not create any suppliers' do
        expect do
          described_class.upload!(suppliers)
        end.not_to change(SupplyTeachers::Supplier, :count)
      end
    end

    context 'when supplier does not exist' do
      before do
        allow(UKPostcode).to receive(:parse).and_return(valid_postcode)
      end

      it 'creates record of successful upload' do
        expect do
          described_class.upload!(suppliers)
        end.to change(SupplyTeachers::Upload, :count).by(1)
      end

      it 'creates supplier' do
        expect do
          described_class.upload!(suppliers)
        end.to change(SupplyTeachers::Supplier, :count).by(1)
      end

      it 'assigns ID to supplier' do
        described_class.upload!(suppliers)

        supplier = SupplyTeachers::Supplier.last
        expect(supplier.id).to eq(supplier_id)
      end

      it 'assigns attributes to supplier' do
        described_class.upload!(suppliers)

        supplier = SupplyTeachers::Supplier.last
        expect(supplier.name).to eq(supplier_name)
      end

      it 'assigns master vendor contact information' do
        described_class.upload!(suppliers)

        supplier = SupplyTeachers::Supplier.last
        expect(supplier).to have_attributes(
          master_vendor_contact_name: 'Mr. Joelle Littel',
          master_vendor_telephone_number: '0800 966090',
          master_vendor_contact_email: 'shawnna@ohara.biz'
        )
      end

      it 'assigns neutral vendor contact information' do
        described_class.upload!(suppliers)

        supplier = SupplyTeachers::Supplier.last
        expect(supplier).to have_attributes(
          neutral_vendor_contact_name: 'Ms. Retta Stehr',
          neutral_vendor_telephone_number: '01677 32220',
          neutral_vendor_contact_email: 'tyree@hoppe.co'
        )
      end

      it 'creates a branch associated with supplier' do
        expect do
          described_class.upload!(suppliers)
        end.to change(SupplyTeachers::Branch, :count).by(1)
      end

      it 'assigns attributes to the branch' do
        described_class.upload!(suppliers)

        supplier = SupplyTeachers::Supplier.last
        branch = supplier.branches.first
        expect(branch.name).to eq(branch_name)
      end

      it 'assigns address_1 and address_2 attributes to the branch' do
        described_class.upload!(suppliers)

        supplier = SupplyTeachers::Supplier.last
        branch = supplier.branches.first
        expect(branch.address_1).to eq(address_1)
        expect(branch.address_2).to eq(address_2)
      end

      it 'assigns county and region attributes to the branch' do
        described_class.upload!(suppliers)

        supplier = SupplyTeachers::Supplier.last
        branch = supplier.branches.first
        expect(branch.region).to eq(region)
        expect(branch.county).to eq(county)
      end

      it 'assigns town and postcode attributes to the branch' do
        described_class.upload!(suppliers)

        supplier = SupplyTeachers::Supplier.last
        branch = supplier.branches.first
        expect(branch.town).to eq(branch_town)
        expect(branch.postcode).to eq(postcode)
      end

      it 'assigns geography-related attributes to the branch' do
        described_class.upload!(suppliers)

        supplier = SupplyTeachers::Supplier.last
        branch = supplier.branches.first
        expect(branch.location.latitude).to be_within(1e-6).of(latitude)
        expect(branch.location.longitude).to be_within(1e-6).of(longitude)
      end

      it 'assigns contact-related attributes to the branch' do
        described_class.upload!(suppliers)

        supplier = SupplyTeachers::Supplier.last
        branch = supplier.branches.first
        expect(branch.telephone_number).to eq(phone_number)
        expect(branch.contact_name).to eq(contact_name)
        expect(branch.contact_email).to eq(contact_email)
      end

      context 'and supplier has no branches' do
        let(:branches) { [] }

        it 'creates a supplier anyway' do
          expect do
            described_class.upload!(suppliers)
          end.to change(SupplyTeachers::Supplier, :count).by(1)
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
            described_class.upload!(suppliers)
          end.to change(SupplyTeachers::Branch, :count).by(2)
        end

        it 'assigns attributes to the branches' do
          described_class.upload!(suppliers)

          supplier = SupplyTeachers::Supplier.last
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
              'job_type' => 'fixed_term',
              'line_no' => 2,
              'fee' => 0.36
            },
            {
              'job_type' => 'qt',
              'line_no' => 3,
              'term' => 'one_week',
              'fee' => 0.40
            }
          ]
        end

        it 'adds nominated worker rates to supplier' do
          described_class.upload!(suppliers)

          supplier = SupplyTeachers::Supplier.last
          expect(supplier.rates.direct_provision).to include(
            an_object_having_attributes(
              job_type: 'nominated',
              mark_up: a_value_within(1e-6).of(0.35)
            )
          )
        end

        it 'adds fixed term rates to supplier' do
          described_class.upload!(suppliers)

          supplier = SupplyTeachers::Supplier.last
          expect(supplier.rates.direct_provision).to include(
            an_object_having_attributes(
              job_type: 'fixed_term',
              mark_up: a_value_within(1e-6).of(0.36)
            )
          )
        end

        it 'imports non-nominated rate data' do
          described_class.upload!(suppliers)

          supplier = SupplyTeachers::Supplier.last
          expect(supplier.rates.direct_provision).to include(
            an_object_having_attributes(
              job_type: 'qt',
              term: 'one_week',
              mark_up: a_value_within(1e-6).of(0.4)
            )
          )
        end
      end

      context 'and supplier has master vendor pricing information' do
        let(:master_vendor_pricing) do
          [
            {
              'job_type' => 'nominated',
              'line_no' => 1,
              'fee' => 0.35
            },
            {
              'job_type' => 'fixed_term',
              'line_no' => 2,
              'fee' => 0.36
            },
            {
              'job_type' => 'qt',
              'line_no' => 3,
              'term' => 'one_week',
              'fee' => 0.40
            }
          ]
        end

        it 'adds nominated worker rates to supplier' do
          described_class.upload!(suppliers)

          supplier = SupplyTeachers::Supplier.last
          expect(supplier.rates.master_vendor).to include(
            an_object_having_attributes(
              job_type: 'nominated',
              mark_up: a_value_within(1e-6).of(0.35)
            )
          )
        end

        it 'adds fixed term rates to supplier' do
          described_class.upload!(suppliers)

          supplier = SupplyTeachers::Supplier.last
          expect(supplier.rates.master_vendor).to include(
            an_object_having_attributes(
              job_type: 'fixed_term',
              mark_up: a_value_within(1e-6).of(0.36)
            )
          )
        end

        it 'imports non-nominated rate data' do
          described_class.upload!(suppliers)

          supplier = SupplyTeachers::Supplier.last
          expect(supplier.rates.master_vendor).to include(
            an_object_having_attributes(
              job_type: 'qt',
              term: 'one_week',
              mark_up: a_value_within(1e-6).of(0.4)
            )
          )
        end
      end

      context 'and supplier has neutral vendor pricing information' do
        let(:neutral_vendor_pricing) do
          [
            {
              'job_type' => 'nominated',
              'line_no' => 1,
              'fee' => 0.35
            },
            {
              'job_type' => 'daily_fee',
              'line_no' => 1,
              'fee' => 1.23
            }
          ]
        end

        it 'adds nominated worker rates to supplier' do
          described_class.upload!(suppliers)

          supplier = SupplyTeachers::Supplier.last
          expect(supplier.rates.neutral_vendor).to include(
            an_object_having_attributes(
              job_type: 'nominated',
              mark_up: a_value_within(1e-6).of(0.35)
            )
          )
        end

        it 'adds daily fee rates to supplier' do
          described_class.upload!(suppliers)

          supplier = SupplyTeachers::Supplier.last
          expect(supplier.rates.neutral_vendor).to include(
            an_object_having_attributes(
              job_type: 'daily_fee',
              daily_fee: 1.23
            )
          )
        end
      end
    end

    context 'when suppliers already exist' do
      before do
        allow(UKPostcode).to receive(:parse).and_return(valid_postcode)
      end

      let!(:first_supplier) { create(:supply_teachers_supplier) }
      let!(:second_supplier) { create(:supply_teachers_supplier) }

      it 'destroys all existing suppliers' do
        described_class.upload!(suppliers)

        expect(SupplyTeachers::Supplier.find_by(id: first_supplier.id))
          .to be_nil
        expect(SupplyTeachers::Supplier.find_by(id: second_supplier.id))
          .to be_nil
      end

      context 'and data for one supplier is invalid' do
        let(:suppliers) do
          [
            {
              'supplier_name' => '',
            }
          ]
        end

        it 'does not create record of unsuccessful upload' do
          expect do
            ignoring_exception(ActiveRecord::RecordInvalid) do
              described_class.upload!(suppliers)
            end
          end.to change(SupplyTeachers::Upload, :count).by(0)
        end

        it 'leaves existing data intact' do
          ignoring_exception(ActiveRecord::RecordInvalid) do
            described_class.upload!(suppliers)
          end

          expect(SupplyTeachers::Supplier.find_by(id: first_supplier.id))
            .to eq(first_supplier)
          expect(SupplyTeachers::Supplier.find_by(id: second_supplier.id))
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
        end.not_to change(SupplyTeachers::Supplier, :count)
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
          described_class.upload!(suppliers)
        end.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'does not create any suppliers' do
        expect do
          ignoring_exception(ActiveRecord::RecordInvalid) do
            described_class.upload!(suppliers)
          end
        end.not_to change(SupplyTeachers::Supplier, :count)
      end
    end
  end

  private

  # rubocop:disable Naming/UncommunicativeMethodParamName:
  def ignoring_exception(e)
    yield
  rescue e
    nil
  end
  # rubocop:enable Naming/UncommunicativeMethodParamName
end
