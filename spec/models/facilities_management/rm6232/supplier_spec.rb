require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::Supplier do
  describe '.lot_data' do
    context 'when selecting a random supplier' do
      let(:supplier) { described_class.order(Arel.sql('RANDOM()')).first }

      it 'has lot data' do
        expect(supplier.lot_data.class.to_s).to eq 'FacilitiesManagement::RM6232::Supplier::LotData::ActiveRecord_Associations_CollectionProxy'
      end
    end

    context 'when looking at a supplier' do
      it 'has some lot data' do
        expect(described_class.find(described_class.pluck(:id).sample).lot_data.count).to be >= 1
      end
    end
  end

  # rubocop:disable RSpec/NestedGroups
  describe '.select_suppliers' do
    let(:result) { described_class.select_suppliers(lot_code, service_codes[..-3], region_codes[..2]) }
    let(:supplier_names) { result.map(&:supplier_name) }

    let(:my_supplier) do
      create(:facilities_management_rm6232_supplier) do |supplier|
        supplier.lot_data = build_list(:facilities_management_rm6232_supplier_lot_data, 1, lot_code: lot_code, service_codes: supplier_services, region_codes: supplier_regions, active: active)
      end
    end

    let(:active) { true }
    let(:selection_two) { { total: false, hard: false, soft: false } }
    let(:service_codes) { FacilitiesManagement::RM6232::Service.where(**selection_one).sample(5).pluck(:code) + FacilitiesManagement::RM6232::Service.where(**selection_two).sample(5).pluck(:code) }
    let(:region_codes) { FacilitiesManagement::Region.all[..-2].sample(5).map(&:code) }

    context 'when all the inputs are nil' do
      let(:lot_code) { nil }
      let(:service_codes) { [] }
      let(:region_codes) { [] }

      it 'returns nothing' do
        expect(result).to be_empty
      end
    end

    context 'when all the inputs are present' do
      let(:supplier_services) { service_codes }
      let(:supplier_regions) { region_codes }

      before { my_supplier }

      context 'when Total FM services are selected' do
        let(:selection_one) { { total: true, hard: true, soft: false } }
        let(:selection_two) { { total: true, hard: false, soft: true } }

        context 'and the lot code is a (lot: 1a)' do
          let(:lot_code) { 'a' }

          it 'returns a list of suppliers that includes my_supplier' do
            expect(supplier_names).to include my_supplier.supplier_name
          end

          context 'and my_supplier is not active' do
            before { my_supplier.update(active: false) }

            it 'returns a list of suppliers that does not include my_supplier' do
              expect(supplier_names).not_to include my_supplier.supplier_name
            end
          end

          context 'and the lot is not active' do
            let(:active) { false }

            it 'returns a list of suppliers that does not include my_supplier' do
              expect(supplier_names).not_to include my_supplier.supplier_name
            end
          end
        end

        context 'and the lot code is b (lot: 1b)' do
          let(:lot_code) { 'b' }

          it 'returns a list of suppliers that includes my_supplier' do
            expect(supplier_names).to include my_supplier.supplier_name
          end

          context 'and my_supplier is not active' do
            before { my_supplier.update(active: false) }

            it 'returns a list of suppliers that does not include my_supplier' do
              expect(supplier_names).not_to include my_supplier.supplier_name
            end
          end

          context 'and the lot is not active' do
            let(:active) { false }

            it 'returns a list of suppliers that does not include my_supplier' do
              expect(supplier_names).not_to include my_supplier.supplier_name
            end
          end
        end

        context 'and the lot code is c (lot: 1c)' do
          let(:lot_code) { 'c' }

          it 'returns a list of suppliers that includes my_supplier' do
            expect(supplier_names).to include my_supplier.supplier_name
          end

          context 'and my_supplier is not active' do
            before { my_supplier.update(active: false) }

            it 'returns a list of suppliers that does not include my_supplier' do
              expect(supplier_names).not_to include my_supplier.supplier_name
            end
          end

          context 'and the lot is not active' do
            let(:active) { false }

            it 'returns a list of suppliers that does not include my_supplier' do
              expect(supplier_names).not_to include my_supplier.supplier_name
            end
          end
        end
      end

      context 'when Hard FM services are selected' do
        let(:selection_one) { { total: true, hard: true, soft: false } }

        context 'and the lot code is a (lot: 2a)' do
          let(:lot_code) { 'a' }

          it 'returns a list of suppliers that includes my_supplier' do
            expect(supplier_names).to include my_supplier.supplier_name
          end

          context 'and my_supplier is not active' do
            before { my_supplier.update(active: false) }

            it 'returns a list of suppliers that does not include my_supplier' do
              expect(supplier_names).not_to include my_supplier.supplier_name
            end
          end

          context 'and the lot is not active' do
            let(:active) { false }

            it 'returns a list of suppliers that does not include my_supplier' do
              expect(supplier_names).not_to include my_supplier.supplier_name
            end
          end
        end

        context 'and the lot code is b (lot: 2b)' do
          let(:lot_code) { 'b' }

          it 'returns a list of suppliers that includes my_supplier' do
            expect(supplier_names).to include my_supplier.supplier_name
          end

          context 'and my_supplier is not active' do
            before { my_supplier.update(active: false) }

            it 'returns a list of suppliers that does not include my_supplier' do
              expect(supplier_names).not_to include my_supplier.supplier_name
            end
          end

          context 'and the lot is not active' do
            let(:active) { false }

            it 'returns a list of suppliers that does not include my_supplier' do
              expect(supplier_names).not_to include my_supplier.supplier_name
            end
          end
        end

        context 'and the lot code is c (lot: 2c)' do
          let(:lot_code) { 'c' }

          it 'returns a list of suppliers that includes my_supplier' do
            expect(supplier_names).to include my_supplier.supplier_name
          end

          context 'and my_supplier is not active' do
            before { my_supplier.update(active: false) }

            it 'returns a list of suppliers that does not include my_supplier' do
              expect(supplier_names).not_to include my_supplier.supplier_name
            end
          end

          context 'and the lot is not active' do
            let(:active) { false }

            it 'returns a list of suppliers that does not include my_supplier' do
              expect(supplier_names).not_to include my_supplier.supplier_name
            end
          end
        end
      end

      context 'when Soft FM services are selected' do
        let(:selection_one) { { total: true, hard: false, soft: true } }

        context 'and the lot code is a (lot: 3a)' do
          let(:lot_code) { 'a' }

          it 'returns a list of suppliers that includes my_supplier' do
            expect(supplier_names).to include my_supplier.supplier_name
          end

          context 'and my_supplier is not active' do
            before { my_supplier.update(active: false) }

            it 'returns a list of suppliers that does not include my_supplier' do
              expect(supplier_names).not_to include my_supplier.supplier_name
            end
          end

          context 'and the lot is not active' do
            let(:active) { false }

            it 'returns a list of suppliers that does not include my_supplier' do
              expect(supplier_names).not_to include my_supplier.supplier_name
            end
          end
        end

        context 'and the lot code is b (lot: 3b)' do
          let(:lot_code) { 'b' }

          it 'returns a list of suppliers that includes my_supplier' do
            expect(supplier_names).to include my_supplier.supplier_name
          end

          context 'and my_supplier is not active' do
            before { my_supplier.update(active: false) }

            it 'returns a list of suppliers that does not include my_supplier' do
              expect(supplier_names).not_to include my_supplier.supplier_name
            end
          end

          context 'and the lot is not active' do
            let(:active) { false }

            it 'returns a list of suppliers that does not include my_supplier' do
              expect(supplier_names).not_to include my_supplier.supplier_name
            end
          end
        end

        context 'and the lot code is c (lot: 3c)' do
          let(:lot_code) { 'c' }

          it 'returns a list of suppliers that includes my_supplier' do
            expect(supplier_names).to include my_supplier.supplier_name
          end

          context 'and my_supplier is not active' do
            before { my_supplier.update(active: false) }

            it 'returns a list of suppliers that does not include my_supplier' do
              expect(supplier_names).not_to include my_supplier.supplier_name
            end
          end

          context 'and the lot is not active' do
            let(:active) { false }

            it 'returns a list of suppliers that does not include my_supplier' do
              expect(supplier_names).not_to include my_supplier.supplier_name
            end
          end
        end
      end
    end

    context 'when my_supplier does not provide all the services' do
      let(:lot_code) { 'a' }
      let(:supplier_services) { service_codes[..-4] }
      let(:supplier_regions) { region_codes }

      before { my_supplier }

      context 'when Total FM services are selected' do
        let(:selection_one) { { total: true, hard: true, soft: false } }
        let(:selection_two) { { total: true, hard: false, soft: true } }

        it 'returns a list of suppliers that does not include my_supplier' do
          expect(supplier_names).not_to include my_supplier.supplier_name
        end
      end

      context 'when Hard FM services are selected' do
        let(:selection_one) { { total: true, hard: true, soft: false } }

        it 'returns a list of suppliers that does not include my_supplier' do
          expect(supplier_names).not_to include my_supplier.supplier_name
        end
      end

      context 'when Soft FM services are selected' do
        let(:selection_one) { { total: true, hard: false, soft: true } }

        it 'returns a list of suppliers that does not include my_supplier' do
          expect(supplier_names).not_to include my_supplier.supplier_name
        end
      end
    end

    context 'when my_supplier does not provide for all the regions' do
      let(:lot_code) { 'a' }
      let(:supplier_services) { service_codes }
      let(:supplier_regions) { region_codes[-3..] }

      before { my_supplier }

      context 'when Total FM services are selected' do
        let(:selection_one) { { total: true, hard: true, soft: false } }
        let(:selection_two) { { total: true, hard: false, soft: true } }

        it 'returns a list of suppliers that does not include my_supplier' do
          expect(supplier_names).not_to include my_supplier.supplier_name
        end
      end

      context 'when Hard FM services are selected' do
        let(:selection_one) { { total: true, hard: true, soft: false } }

        it 'returns a list of suppliers that does not include my_supplier' do
          expect(supplier_names).not_to include my_supplier.supplier_name
        end
      end

      context 'when Soft FM services are selected' do
        let(:selection_one) { { total: true, hard: false, soft: true } }

        it 'returns a list of suppliers that does not include my_supplier' do
          expect(supplier_names).not_to include my_supplier.supplier_name
        end
      end
    end
  end
  # rubocop:enable RSpec/NestedGroups
end
