require 'rails_helper'

RSpec.describe Upload do
  let(:framework_id) { 'RM6376' }
  let(:result) { described_class.upload!(framework_id, suppliers) }

  let(:supplier_id) { SecureRandom.uuid }
  let(:supplier_name) { Faker::Name.unique.name }
  let(:trading_name) { Faker::Name.unique.name }
  let(:additional_identifier) { SecureRandom.uuid }

  let(:branch_name) { 'Head Office' }
  let(:branch_town) { 'Guildford' }
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

  let(:additional_details) { {} }
  let(:supplier_framework_lots) { [] }

  let(:suppliers) do
    [
      {
        id: supplier_id,
        name: supplier_name,
        additional_details: {
          trading_name:,
          additional_identifier:,
        },
        supplier_frameworks: [
          {
            framework_id: 'RM6376',
            enabled: true,
            supplier_framework_contact_detail: {
              additional_details:,
            },
            supplier_framework_lots: supplier_framework_lots
          },
        ]
      }
    ]
  end

  describe '.upload!' do
    context 'when supplier list is empty' do
      let(:suppliers) { [] }

      it 'does not create any suppliers' do
        expect { result }.not_to change(Supplier, :count)
      end
    end

    context 'when supplier does not exist' do
      it 'creates record of successful upload' do
        expect { result }.to change(described_class, :count).by(1)
      end

      it 'creates supplier' do
        expect { result }.to change(Supplier, :count).by(1)
      end

      it 'assigns ID to supplier' do
        result

        supplier = Supplier.last
        expect(supplier.id).to eq(supplier_id)
      end

      it 'assigns attributes to supplier' do
        result

        supplier = Supplier.last
        expect(supplier.name).to eq(supplier_name)
        expect(supplier.trading_name).to eq(trading_name)
        expect(supplier.additional_identifier).to eq(additional_identifier)
      end

      it 'creates supplier framework' do
        expect { result }.to change(Supplier::Framework, :count).by(1)
      end

      it 'assigns contact-related attributes to supplier framework' do
        result

        contact_detail = Supplier::Framework.last.contact_detail
        expect(contact_detail.email).to be_nil
        expect(contact_detail.telephone_number).to be_nil
      end

      context 'when additional_details are provided' do
        let(:additional_details) do
          {
            managed_service_provider_name: Faker::Name.unique.name,
            managed_service_provider_email: Faker::Internet.unique.email,
            managed_service_provider_telephone_number: Faker::PhoneNumber.unique.phone_number
          }
        end

        it 'assigns managed service provider contact-related attributes to supplier framework' do
          result

          contact_detail = Supplier::Framework.last.contact_detail
          expect(contact_detail.additional_details).to eq(additional_details.deep_stringify_keys)
        end
      end

      context 'and supplier has rates' do
        let(:supplier_framework_lots) do
          [
            {
              lot_id: 'RM6376.1',
              enabled: true,
              supplier_framework_lot_services: [],
              supplier_framework_lot_jurisdictions: [
                {
                  jurisdiction_id: 'RM6376.GB'
                }
              ],
              supplier_framework_lot_rates: [
                {
                  position_id: 'RM6376.1.1',
                  rate: 10000,
                  jurisdiction_id: 'RM6376.GB'
                }
              ],
              supplier_framework_lot_branches: []
            },
            {
              lot_id: 'RM6376.2',
              enabled: true,
              supplier_framework_lot_services: [],
              supplier_framework_lot_jurisdictions: [
                {
                  jurisdiction_id: 'RM6376.GB'
                }
              ],
              supplier_framework_lot_rates: [
                {
                  position_id: 'RM6376.2.1',
                  rate: 20000,
                  jurisdiction_id: 'RM6376.GB'
                }
              ],
              supplier_framework_lot_branches: []
            },
          ]
        end
        let(:supplier_framework) { Supplier::Framework.last }

        it 'creates supplier framework lot jurisdictions associated with supplier' do
          expect { result }.to change(Supplier::Framework::Lot::Jurisdiction, :count).by(2)
        end

        it 'creates supplier framework lot rates associated with supplier' do
          expect { result }.to change(Supplier::Framework::Lot::Rate, :count).by(2)
        end

        it 'assigns attributes to the jurisdictions' do
          result

          expect(supplier_framework.lots.map { |lot| lot.jurisdictions.pluck(:jurisdiction_id) }).to eq([['RM6376.GB'], ['RM6376.GB']])
        end

        it 'assigns attributes to the rates' do
          result

          expect(supplier_framework.lots.map { |lot| lot.rates.pluck(:position_id, :rate) }).to eq([[['RM6376.1.1', 10000]], [['RM6376.2.1', 20000]]])
        end
      end

      context 'and supplier has branches' do
        let(:supplier_framework_lots) do
          [
            {
              lot_id: 'RM6376.1',
              enabled: true,
              supplier_framework_lot_services: [],
              supplier_framework_lot_jurisdictions: [],
              supplier_framework_lot_rates: [],
              supplier_framework_lot_branches: [
                {
                  lat: latitude,
                  lon: longitude,
                  postcode: postcode,
                  contact_name: contact_name,
                  contact_email: contact_email,
                  telephone_number: phone_number,
                  name: branch_name,
                  town: branch_town,
                  address_line_1: address_1,
                  address_line_2: address_2,
                  county: county,
                  region: region
                }
              ]
            }
          ]
        end

        let(:branch) do
          result

          supplier_framework.lots.first.branches.first
        end

        let(:supplier_framework) { Supplier::Framework.last }

        it 'creates supplier framework lot associated with supplier' do
          expect { result }.to change(Supplier::Framework::Lot, :count).by(1)
        end

        it 'creates supplier framework lot branches associated with supplier' do
          expect { result }.to change(Supplier::Framework::Lot::Branch, :count).by(1)
        end

        it 'assigns attributes to the framework lot' do
          result

          expect(supplier_framework.lots.pluck(:lot_id)).to eq(['RM6376.1'])
        end

        it 'assigns attributes to the branch' do
          expect(branch.name).to eq(branch_name)
        end

        it 'assigns address_line_1 and address_line_2 attributes to the branch' do
          expect(branch.address_line_1).to eq(address_1)
          expect(branch.address_line_2).to eq(address_2)
        end

        it 'assigns county and region attributes to the branch' do
          expect(branch.region).to eq(region)
          expect(branch.county).to eq(county)
        end

        it 'assigns town and postcode attributes to the branch' do
          expect(branch.town).to eq(branch_town)
          expect(branch.postcode).to eq(postcode)
        end

        it 'assigns geography-related attributes to the branch' do
          expect(branch.location.latitude).to be_within(1e-6).of(latitude)
          expect(branch.location.longitude).to be_within(1e-6).of(longitude)
        end

        it 'assigns contact-related attributes to the branch' do
          expect(branch.telephone_number).to eq(phone_number)
          expect(branch.contact_name).to eq(contact_name)
          expect(branch.contact_email).to eq(contact_email)
        end
      end
    end

    context 'when suppliers already exist' do
      let!(:first_supplier_framework) { create(:supplier_framework, framework_id:) }
      let!(:second_supplier_framework) { create(:supplier_framework, framework_id:) }

      it 'destroys all existing suppliers' do
        result

        expect(Supplier.find_by(id: first_supplier_framework.supplier_id)).to be_nil
        expect(Supplier.find_by(id: second_supplier_framework.supplier_id)).to be_nil
      end

      it 'destroys all existing supplier frameworks' do
        result

        expect(Supplier::Framework.find_by(id: first_supplier_framework.id)).to be_nil
        expect(Supplier::Framework.find_by(id: second_supplier_framework.id)).to be_nil
      end

      context 'and data for one supplier is invalid' do
        let(:supplier_name) { '' }

        it 'does not create record of unsuccessful upload' do
          expect do
            ignoring_exception(ActiveRecord::RecordInvalid) { result }
          end.not_to change(described_class, :count)
        end

        it 'leaves existing data intact' do
          ignoring_exception(ActiveRecord::RecordInvalid) { result }

          expect(Supplier.find_by(id: first_supplier_framework.supplier_id)).to eq(first_supplier_framework.supplier)
          expect(Supplier.find_by(id: second_supplier_framework.supplier_id)).to eq(second_supplier_framework.supplier)
        end
      end
    end

    context 'when data for supplier is invalid' do
      let(:supplier_name) { '' }

      it 'raises ActiveRecord::RecordInvalid exception' do
        expect { result }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'does not create any suppliers' do
        expect do
          ignoring_exception(ActiveRecord::RecordInvalid) { result }
        end.not_to change(Supplier, :count)
      end
    end

    context 'when data for rates is invalid' do
      let(:supplier_framework_lots) do
        [
          {
            lot_id: 'RM6376.1',
            enabled: true,
            supplier_framework_lot_services: [],
            supplier_framework_lot_jurisdictions: [],
            supplier_framework_lot_rates: [],
            supplier_framework_lot_branches: [
              {
                lat: latitude,
                lon: longitude,
                postcode: postcode,
                contact_name: contact_name,
                contact_email: contact_email,
                telephone_number: phone_number,
                name: branch_name,
                town: branch_town,
                address_line_1: address_1,
                address_line_2: address_2,
                county: county,
                region: region
              }
            ]
          }
        ]
      end
      let(:postcode) { '' }

      it 'raises ActiveRecord::RecordInvalid exception' do
        expect { result }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'does not create any suppliers' do
        expect do
          ignoring_exception(ActiveRecord::RecordInvalid) { result }
        end.not_to change(Supplier, :count)
      end
    end

    context 'when data for branches is invalid' do
      let(:supplier_framework_lots) do
        [
          {
            lot_id: 'RM6376.1',
            enabled: true,
            supplier_framework_lot_services: [],
            supplier_framework_lot_jurisdictions: [
              {
                jurisdiction_id: 'RM6376.GB'
              }
            ],
            supplier_framework_lot_rates: [
              {
                position_id: 'RM6376.1.441',
                rate: 10000,
                jurisdiction_id: 'RM6376.GB'
              }
            ],
            supplier_framework_lot_branches: []
          },
          {
            lot_id: 'RM6376.3',
            enabled: true,
            supplier_framework_lot_services: [],
            supplier_framework_lot_jurisdictions: [
              {
                jurisdiction_id: 'RM6376.GB'
              }
            ],
            supplier_framework_lot_rates: [
              {
                position_id: 'RM6376.3.1',
                rate: 20000,
                jurisdiction_id: 'RM6376.GB'
              }
            ],
            supplier_framework_lot_branches: []
          },
        ]
      end

      it 'raises ActiveRecord::InvalidForeignKey exception' do
        expect { result }.to raise_error(ActiveRecord::InvalidForeignKey)
      end

      it 'does not create any suppliers' do
        expect do
          ignoring_exception(ActiveRecord::InvalidForeignKey) { result }
        end.not_to change(Supplier, :count)
      end
    end
  end

  describe '.smart_upload!' do
    let(:result) { described_class.upload!(framework_id, new_suppliers) }

    let(:supplier_framework_lots) do
      [
        {
          lot_id: 'RM6376.1',
          enabled: true,
          supplier_framework_lot_services: [],
          supplier_framework_lot_jurisdictions: [
            {
              jurisdiction_id: 'RM6376.GB'
            }
          ],
          supplier_framework_lot_rates: [
            {
              position_id: 'RM6376.1.1',
              rate: 10000,
              jurisdiction_id: 'RM6376.GB'
            }
          ],
          supplier_framework_lot_branches: [
            {
              lat: latitude,
              lon: longitude,
              postcode: postcode,
              contact_name: contact_name,
              contact_email: contact_email,
              telephone_number: phone_number,
              name: branch_name,
              town: branch_town,
              address_line_1: address_1,
              address_line_2: address_2,
              county: county,
              region: region
            }
          ]
        },
        {
          lot_id: 'RM6376.2',
          enabled: true,
          supplier_framework_lot_services: [],
          supplier_framework_lot_jurisdictions: [
            {
              jurisdiction_id: 'RM6376.GB'
            }
          ],
          supplier_framework_lot_rates: [
            {
              position_id: 'RM6376.2.1',
              rate: 20000,
              jurisdiction_id: 'RM6376.GB'
            }
          ],
          supplier_framework_lot_branches: []
        }
      ]
    end

    let(:additional_details) do
      {
        managed_service_provider_name: Faker::Name.unique.name,
        managed_service_provider_email: Faker::Internet.unique.email,
        managed_service_provider_telephone_number: Faker::PhoneNumber.unique.phone_number
      }
    end

    before { described_class.upload!(framework_id, suppliers) }

    context 'and the supplier does not exist' do
      let(:new_supplier_id) { SecureRandom.uuid }
      let(:new_supplier_name) { Faker::Name.unique.name }
      let(:new_trading_name) { Faker::Name.unique.name }
      let(:new_additional_identifier) { SecureRandom.uuid }

      let(:new_suppliers) do
        [
          {
            id: supplier_id,
            name: supplier_name,
            additional_details: {
              trading_name:,
              additional_identifier:,
            },
            supplier_frameworks: [
              {
                framework_id: 'RM6376',
                enabled: true,
                supplier_framework_contact_detail: {
                  additional_details:,
                },
                supplier_framework_lots: supplier_framework_lots
              },
            ]
          },
          {
            id: new_supplier_id,
            name: new_supplier_name,
            additional_details: {
              trading_name: new_trading_name,
              additional_identifier: new_additional_identifier,
            },
            supplier_frameworks: [
              {
                framework_id: 'RM6376',
                enabled: true,
                supplier_framework_contact_detail: {
                  additional_details:,
                },
                supplier_framework_lots: supplier_framework_lots
              },
            ]
          }
        ]
      end

      it 'creates record of successful upload' do
        expect { result }.to change(described_class, :count).by(1)
      end

      it 'creates supplier' do
        expect { result }.to change(Supplier, :count).by(1)
      end

      it 'creates supplier framework' do
        expect { result }.to change(Supplier::Framework, :count).by(1)
      end

      it 'creates supplier framework contact detail' do
        expect { result }.to change(Supplier::Framework::ContactDetail, :count).by(1)
      end

      it 'creates supplier framework lot associated with supplier' do
        expect { result }.to change(Supplier::Framework::Lot, :count).by(2)
      end

      it 'creates supplier framework lot jurisdictions associated with supplier' do
        expect { result }.to change(Supplier::Framework::Lot::Jurisdiction, :count).by(2)
      end

      it 'creates supplier framework lot rates associated with supplier' do
        expect { result }.to change(Supplier::Framework::Lot::Rate, :count).by(2)
      end

      it 'creates supplier framework lot branches associated with supplier' do
        expect { result }.to change(Supplier::Framework::Lot::Branch, :count).by(1)
      end
    end

    context 'and the supplier does exist' do
      let(:new_supplier_name) { Faker::Name.unique.name }

      let(:new_suppliers) do
        [
          {
            id: supplier_id,
            name: new_supplier_name,
            additional_details: {
              trading_name:,
              additional_identifier:,
            },
            supplier_frameworks: [
              {
                framework_id: 'RM6376',
                enabled: true,
                supplier_framework_contact_detail: {
                  additional_details:,
                },
                supplier_framework_lots: []
              },
            ]
          },
        ]
      end

      it 'creates record of successful upload' do
        expect { result }.to change(described_class, :count).by(1)
      end

      it 'does not create a supplier' do
        expect { result }.not_to change(Supplier, :count)
      end

      it 'updates the supplier name' do
        result

        supplier = Supplier.last
        expect(supplier.name).to eq(new_supplier_name)
        expect(supplier.trading_name).to eq(trading_name)
        expect(supplier.additional_identifier).to eq(additional_identifier)
      end

      it 'does not create an additional supplier framework' do
        expect { result }.not_to change(Supplier::Framework, :count)
      end

      it 'does not create an additional supplier framework contact detail' do
        expect { result }.not_to change(Supplier::Framework::ContactDetail, :count)
      end

      it 'removes the supplier framework lot associated with supplier' do
        expect { result }.to change(Supplier::Framework::Lot, :count).by(-2)
      end

      it 'creates supplier framework lot jurisdictions associated with supplier' do
        expect { result }.to change(Supplier::Framework::Lot::Jurisdiction, :count).by(-2)
      end

      it 'removes the supplier framework lot rates associated with supplier' do
        expect { result }.to change(Supplier::Framework::Lot::Rate, :count).by(-2)
      end

      it 'removes the supplier framework lot branches associated with supplier' do
        expect { result }.to change(Supplier::Framework::Lot::Branch, :count).by(-1)
      end
    end
  end

  private

  def ignoring_exception(exception)
    yield
  rescue exception
    nil
  end
end
