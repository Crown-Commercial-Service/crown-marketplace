require 'rails_helper'

RSpec.describe Upload do
  let(:framework_id) { 'RM6309' }
  let(:result) { described_class.upload!(framework_id, suppliers) }

  let(:supplier_id) { SecureRandom.uuid }
  let(:supplier_name) { Faker::Name.unique.name }
  let(:supplier_duns) { Faker::Company.unique.duns_number.delete('-').to_s }
  let(:email) { Faker::Internet.unique.email }
  let(:telephone_number) { Faker::PhoneNumber.unique.phone_number }

  let(:supplier_framework_lots) { [] }

  let(:suppliers) do
    [
      {
        id: supplier_id,
        name: supplier_name,
        duns_number: supplier_duns,
        supplier_frameworks: [
          {
            framework_id: 'RM6309',
            enabled: true,
            supplier_framework_contact_detail: {
              email:,
              telephone_number:,
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
      end

      it 'creates supplier framework' do
        expect { result }.to change(Supplier::Framework, :count).by(1)
      end

      it 'assigns contact-related attributes to supplier framework' do
        result

        contact_detail = Supplier::Framework.last.contact_detail
        expect(contact_detail.email).to eq(email)
        expect(contact_detail.telephone_number).to eq(telephone_number)
      end

      context 'and supplier is offering lot 1 and 2 services' do
        let(:supplier_framework_lots) do
          [
            {
              lot_id: 'RM6309.1',
              enabled: true,
              supplier_framework_lot_services: [
                {
                  service_id: 'RM6309.1.1'
                },
                {
                  service_id: 'RM6309.1.2'
                }
              ],
              supplier_framework_lot_jurisdictions: [],
              supplier_framework_lot_rates: [],
              supplier_framework_lot_branches: []
            },
            {
              lot_id: 'RM6309.2',
              enabled: true,
              supplier_framework_lot_services: [
                {
                  service_id: 'RM6309.2.1'
                },
              ],
              supplier_framework_lot_jurisdictions: [],
              supplier_framework_lot_rates: [],
              supplier_framework_lot_branches: []
            }
          ]
        end

        let(:supplier_framework) { Supplier::Framework.last }

        it 'creates supplier framework lot associated with supplier' do
          expect { result }.to change(Supplier::Framework::Lot, :count).by(2)
        end

        it 'creates supplier framework lot services associated with supplier' do
          expect { result }.to change(Supplier::Framework::Lot::Service, :count).by(3)
        end

        it 'assigns attributes to the framework lot' do
          result

          expect(supplier_framework.lots.pluck(:lot_id)).to eq(['RM6309.1', 'RM6309.2'])
        end

        it 'assigns attributes to the framework lot services' do
          result

          expect(supplier_framework.lots.map { |lot| lot.services.pluck(:service_id) }).to eq([['RM6309.1.1', 'RM6309.1.2'], ['RM6309.2.1']])
        end
      end

      context 'and supplier has rates' do
        let(:supplier_framework_lots) do
          [
            {
              lot_id: 'RM6309.1',
              enabled: true,
              supplier_framework_lot_services: [],
              supplier_framework_lot_jurisdictions: [
                {
                  jurisdiction_id: 'GB'
                }
              ],
              supplier_framework_lot_rates: [
                {
                  position_id: 8,
                  rate: 10000,
                  jurisdiction_id: 'GB'
                }
              ],
              supplier_framework_lot_branches: []
            },
            {
              lot_id: 'RM6309.3',
              enabled: true,
              supplier_framework_lot_services: [],
              supplier_framework_lot_jurisdictions: [
                {
                  jurisdiction_id: 'GB'
                }
              ],
              supplier_framework_lot_rates: [
                {
                  position_id: 8,
                  rate: 20000,
                  jurisdiction_id: 'GB'
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

          expect(supplier_framework.lots.map { |lot| lot.jurisdictions.pluck(:jurisdiction_id) }).to eq([['GB'], ['GB']])
        end

        it 'assigns attributes to the rates' do
          result

          expect(supplier_framework.lots.map { |lot| lot.rates.pluck(:position_id, :rate) }).to eq([[[8, 10000]], [[8, 20000]]])
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

    context 'when data for services is invalid' do
      let(:supplier_framework_lots) do
        [
          {
            lot_id: 'RM6309.1',
            enabled: true,
            supplier_framework_lot_services: [
              {
                service_id: 'RM6309.1.1'
              },
              {
                service_id: 'invalid'
              }
            ],
            supplier_framework_lot_jurisdictions: [],
            supplier_framework_lot_rates: [],
            supplier_framework_lot_branches: []
          },
          {
            lot_id: 'RM6309.2',
            enabled: true,
            supplier_framework_lot_services: [
              {
                service_id: 'RM6309.2.1'
              },
            ],
            supplier_framework_lot_jurisdictions: [],
            supplier_framework_lot_rates: [],
            supplier_framework_lot_branches: []
          }
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

    context 'when data for rates is invalid' do
      let(:supplier_framework_lots) do
        [
          {
            lot_id: 'RM6309.1',
            enabled: true,
            supplier_framework_lot_services: [],
            supplier_framework_lot_jurisdictions: [
              {
                jurisdiction_id: 'GB'
              }
            ],
            supplier_framework_lot_rates: [
              {
                position_id: 88,
                rate: 10000,
                jurisdiction_id: 'GB'
              }
            ],
            supplier_framework_lot_branches: []
          },
          {
            lot_id: 'RM6309.3',
            enabled: true,
            supplier_framework_lot_services: [],
            supplier_framework_lot_jurisdictions: [
              {
                jurisdiction_id: 'GB'
              }
            ],
            supplier_framework_lot_rates: [
              {
                position_id: 8,
                rate: 20000,
                jurisdiction_id: 'GB'
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
          lot_id: 'RM6309.1',
          enabled: true,
          supplier_framework_lot_services: [
            {
              service_id: 'RM6309.1.1'
            },
            {
              service_id: 'RM6309.1.2'
            }
          ],
          supplier_framework_lot_jurisdictions: [
            {
              jurisdiction_id: 'GB'
            }
          ],
          supplier_framework_lot_rates: [
            {
              position_id: 8,
              rate: 10000,
              jurisdiction_id: 'GB'
            }
          ],
          supplier_framework_lot_branches: []
        },
        {
          lot_id: 'RM6309.2',
          enabled: true,
          supplier_framework_lot_services: [
            {
              service_id: 'RM6309.2.1'
            },
          ],
          supplier_framework_lot_jurisdictions: [
            {
              jurisdiction_id: 'GB'
            }
          ],
          supplier_framework_lot_rates: [
            {
              position_id: 8,
              rate: 20000,
              jurisdiction_id: 'GB'
            }
          ],
          supplier_framework_lot_branches: []
        }
      ]
    end

    before { described_class.upload!(framework_id, suppliers) }

    context 'and the supplier does not exist' do
      let(:new_supplier_id) { SecureRandom.uuid }
      let(:new_supplier_name) { Faker::Name.unique.name }
      let(:new_supplier_duns) { Faker::Company.unique.duns_number.delete('-').to_s }

      let(:new_suppliers) do
        [
          {
            id: supplier_id,
            name: supplier_name,
            duns_number: supplier_duns,
            supplier_frameworks: [
              {
                framework_id: 'RM6309',
                enabled: true,
                supplier_framework_contact_detail: {
                  email:,
                  telephone_number:,
                },
                supplier_framework_lots: supplier_framework_lots
              },
            ]
          },
          {
            id: new_supplier_id,
            name: new_supplier_name,
            duns_number: new_supplier_duns,
            supplier_frameworks: [
              {
                framework_id: 'RM6309',
                enabled: true,
                supplier_framework_contact_detail: {
                  email:,
                  telephone_number:,
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

      it 'creates supplier framework lot services associated with supplier' do
        expect { result }.to change(Supplier::Framework::Lot::Service, :count).by(3)
      end

      it 'creates supplier framework lot jurisdictions associated with supplier' do
        expect { result }.to change(Supplier::Framework::Lot::Jurisdiction, :count).by(2)
      end

      it 'creates supplier framework lot rates associated with supplier' do
        expect { result }.to change(Supplier::Framework::Lot::Rate, :count).by(2)
      end
    end

    context 'and the supplier does exist with the same duns number' do
      let(:new_supplier_name) { Faker::Name.unique.name }

      let(:new_suppliers) do
        [
          {
            id: supplier_id,
            name: new_supplier_name,
            duns_number: supplier_duns,
            supplier_frameworks: [
              {
                framework_id: 'RM6309',
                enabled: true,
                supplier_framework_contact_detail: {
                  email:,
                  telephone_number:,
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

      it 'removes the supplier framework lot services associated with supplier' do
        expect { result }.to change(Supplier::Framework::Lot::Service, :count).by(-3)
      end

      it 'creates supplier framework lot jurisdictions associated with supplier' do
        expect { result }.to change(Supplier::Framework::Lot::Jurisdiction, :count).by(-2)
      end

      it 'removes the supplier framework lot rates associated with supplier' do
        expect { result }.to change(Supplier::Framework::Lot::Rate, :count).by(-2)
      end
    end

    context 'and the supplier does exist with a different duns number' do
      let(:new_supplier_duns) { Faker::Company.unique.duns_number.delete('-').to_s }

      let(:new_suppliers) do
        [
          {
            id: supplier_id,
            name: supplier_name,
            duns_number: new_supplier_duns,
            supplier_frameworks: [
              {
                framework_id: 'RM6309',
                enabled: true,
                supplier_framework_contact_detail: {
                  email:,
                  telephone_number:,
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

      it 'updates the supplier duns' do
        result

        supplier = Supplier.last
        expect(supplier.duns_number).to eq(new_supplier_duns)
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

      it 'removes the supplier framework lot services associated with supplier' do
        expect { result }.to change(Supplier::Framework::Lot::Service, :count).by(-3)
      end

      it 'creates supplier framework lot jurisdictions associated with supplier' do
        expect { result }.to change(Supplier::Framework::Lot::Jurisdiction, :count).by(-2)
      end

      it 'removes the supplier framework lot rates associated with supplier' do
        expect { result }.to change(Supplier::Framework::Lot::Rate, :count).by(-2)
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
