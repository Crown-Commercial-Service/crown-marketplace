require 'rails_helper'

RSpec.describe Supplier::Framework::Lot::Branch do
  let(:supplier_framework_lot_branch) { create(:supplier_framework_lot_branch) }

  describe 'associations' do
    it { expect(supplier_framework_lot_branch).to belong_to(:supplier_framework_lot) }

    it 'has the supplier_framework_lot relationship' do
      expect(supplier_framework_lot_branch.supplier_framework_lot).to be_present
    end
  end

  describe 'validation' do
    it { expect(supplier_framework_lot_branch).to be_valid }

    it 'is not valid if postcode is nil' do
      supplier_framework_lot_branch.postcode = nil
      expect(supplier_framework_lot_branch).not_to be_valid
    end

    it 'is not valid if postcode is blank' do
      supplier_framework_lot_branch.postcode = ''
      expect(supplier_framework_lot_branch).not_to be_valid
    end

    it 'is not valid if postcode is nonsense' do
      supplier_framework_lot_branch.postcode = 'nonsense'
      expect(supplier_framework_lot_branch).not_to be_valid
      expect(supplier_framework_lot_branch.errors[:postcode].first).to eq('Enter a valid postcode')
    end

    it 'is not valid if location is blank' do
      supplier_framework_lot_branch.location = nil
      expect(supplier_framework_lot_branch).not_to be_valid
    end

    it 'is not valid if telephone_number is blank' do
      supplier_framework_lot_branch.telephone_number = ''
      expect(supplier_framework_lot_branch).not_to be_valid
    end

    it 'is not valid if contact_name is blank' do
      supplier_framework_lot_branch.contact_name = ''
      expect(supplier_framework_lot_branch).not_to be_valid
    end

    it 'is not valid if contact_email is blank' do
      supplier_framework_lot_branch.contact_email = ''
      expect(supplier_framework_lot_branch).not_to be_valid
    end
  end

  describe '.search' do
    let(:search_result) { described_class.search(point, lot_id:, position_id:, radius:) }
    let(:framework_id) { 'RM6238' }
    let(:lot_id) { 'RM6238.1' }
    let(:position_id) { 41 }
    let(:radius) { 25 }
    let(:supplier_framework) { create(:supplier_framework, framework_id:) }
    let(:supplier_framework_lot) { create(:supplier_framework_lot, supplier_framework:, lot_id:) }

    context 'when three branches exist in different locations' do
      let!(:london_1) do
        create(
          :supplier_framework_lot_branch,
          supplier_framework_lot: supplier_framework_lot,
          location: Geocoding.point(latitude: 51.5201, longitude: -0.0759)
        )
      end

      let!(:london_2) do
        create(
          :supplier_framework_lot_branch,
          supplier_framework_lot: supplier_framework_lot,
          location: Geocoding.point(latitude: 51.5263, longitude: -0.0858)
        )
      end

      let!(:edinburgh) do
        create(
          :supplier_framework_lot_branch,
          supplier_framework_lot: supplier_framework_lot,
          location: Geocoding.point(latitude: 55.9619, longitude: -3.1953)
        )
      end

      let(:point) { Geocoding.point(latitude: 51.5255, longitude: -0.0587) }

      before { create(:supplier_framework_lot_rate, supplier_framework_lot:, position_id:) }

      it 'includes nearby branches' do
        expect(search_result).to include(london_1, london_2)
      end

      it 'excludes far away branches' do
        expect(search_result).not_to include(edinburgh)
      end
    end

    context 'when there are branches outside of the search area' do
      let!(:branch_within_search_area) do
        create(
          :supplier_framework_lot_branch,
          supplier_framework_lot: supplier_framework_lot,
          location: Geocoding.point(latitude: 51.5172265, longitude: -0.1275961)
        )
      end

      let!(:branch_outside_search_area) do
        create(
          :supplier_framework_lot_branch,
          supplier_framework_lot: supplier_framework_lot,
          location: Geocoding.point(latitude: 50.7230521, longitude: -2.0430911)
        )
      end

      let(:position_id) { 39 }
      let(:point) { Geocoding.point(latitude: 51.5, longitude: 0) }

      before { create(:supplier_framework_lot_rate, supplier_framework_lot:, position_id:) }

      it 'includes branches within 25 miles' do
        expect(search_result).to include(branch_within_search_area)
      end

      it 'excludes branches outside 25 miles' do
        expect(search_result).not_to include(branch_outside_search_area)
      end
    end

    context 'when there are suppliers without nominated worker rates' do
      let!(:branch_with_nominated_worker_rates) do
        supplier_framework = create(:supplier_framework, framework_id:)
        supplier_framework_lot = create(:supplier_framework_lot, supplier_framework:, lot_id:)

        create(:supplier_framework_lot_rate, supplier_framework_lot:, position_id:)

        create(
          :supplier_framework_lot_branch,
          supplier_framework_lot: supplier_framework_lot,
          location: Geocoding.point(latitude: 0, longitude: 0)
        )
      end
      let!(:branch_with_no_nominated_worker_rates) do
        supplier_framework = create(:supplier_framework, framework_id:)
        supplier_framework_lot = create(:supplier_framework_lot, supplier_framework:, lot_id:)

        create(:supplier_framework_lot_rate, supplier_framework_lot: supplier_framework_lot, position_id: 41)

        create(
          :supplier_framework_lot_branch,
          supplier_framework_lot: supplier_framework_lot,
          location: Geocoding.point(latitude: 0, longitude: 0)
        )
      end
      let!(:branch_with_master_vendor_nominated_worker_rate) do
        supplier_framework = create(:supplier_framework, framework_id:)
        supplier_framework_lot = create(:supplier_framework_lot, supplier_framework: supplier_framework, lot_id: 'RM6238.2.1')

        create(:supplier_framework_lot_rate, supplier_framework_lot:, position_id:)

        create(
          :supplier_framework_lot_branch,
          supplier_framework_lot: supplier_framework_lot,
          location: Geocoding.point(latitude: 0, longitude: 0)
        )
      end

      let(:position_id) { 39 }
      let(:point) { Geocoding.point(latitude: 0, longitude: 0) }

      it 'includes suppliers that have nominated worker rates' do
        expect(search_result).to include(branch_with_nominated_worker_rates)
      end

      it "excludes suppliers that don't have nominated worker rates" do
        expect(search_result).not_to include(branch_with_no_nominated_worker_rates)
      end

      it "excludes suppliers that don't have nominated worker rates for direct provision" do
        expect(search_result).not_to include(branch_with_master_vendor_nominated_worker_rate)
      end
    end

    context 'when there are suppliers with fixed term rates' do
      let!(:branch_with_fixed_term_rates) do
        supplier_framework = create(:supplier_framework, framework_id:)
        supplier_framework_lot = create(:supplier_framework_lot, supplier_framework:, lot_id:)

        create(:supplier_framework_lot_rate, supplier_framework_lot:, position_id:)

        create(
          :supplier_framework_lot_branch,
          supplier_framework_lot: supplier_framework_lot,
          location: Geocoding.point(latitude: 0, longitude: 0)
        )
      end
      let!(:branch_with_no_fixed_term_rates) do
        supplier_framework = create(:supplier_framework, framework_id:)
        supplier_framework_lot = create(:supplier_framework_lot, supplier_framework:, lot_id:)

        create(:supplier_framework_lot_rate, supplier_framework_lot: supplier_framework_lot, position_id: 41)

        create(
          :supplier_framework_lot_branch,
          supplier_framework_lot: supplier_framework_lot,
          location: Geocoding.point(latitude: 0, longitude: 0)
        )
      end
      let!(:branch_with_master_vendor_fixed_term_rate) do
        supplier_framework = create(:supplier_framework, framework_id:)
        supplier_framework_lot = create(:supplier_framework_lot, supplier_framework: supplier_framework, lot_id: 'RM6238.2.1')

        create(:supplier_framework_lot_rate, supplier_framework_lot:, position_id:)

        create(
          :supplier_framework_lot_branch,
          supplier_framework_lot: supplier_framework_lot,
          location: Geocoding.point(latitude: 0, longitude: 0)
        )
      end

      let(:position_id) { 40 }
      let(:point) { Geocoding.point(latitude: 0, longitude: 0) }

      it 'includes suppliers that have fixed term rates' do
        expect(search_result).to include(branch_with_fixed_term_rates)
      end

      it "excludes suppliers that don't have fixed term rates" do
        expect(search_result).not_to include(branch_with_no_fixed_term_rates)
      end

      it "excludes suppliers that don't have fixed term rates for direct provision" do
        expect(search_result).not_to include(branch_with_master_vendor_fixed_term_rate)
      end
    end

    context 'when there are suppliers with different nominated worker rates' do
      let!(:branch_of_cheaper_supplier) do
        supplier_framework = create(:supplier_framework, framework_id:)
        supplier_framework_lot = create(:supplier_framework_lot, supplier_framework:, lot_id:)

        create(:supplier_framework_lot_rate, supplier_framework_lot: supplier_framework_lot, position_id: position_id, rate: 1000)

        create(
          :supplier_framework_lot_branch,
          supplier_framework_lot: supplier_framework_lot,
          location: Geocoding.point(latitude: 0, longitude: 0)
        )
      end
      let!(:branch_of_costlier_supplier) do
        supplier_framework = create(:supplier_framework, framework_id:)
        supplier_framework_lot = create(:supplier_framework_lot, supplier_framework:, lot_id:)

        create(:supplier_framework_lot_rate, supplier_framework_lot: supplier_framework_lot, position_id: position_id, rate: 9000)

        create(
          :supplier_framework_lot_branch,
          supplier_framework_lot: supplier_framework_lot,
          location: Geocoding.point(latitude: 0, longitude: 0)
        )
      end

      let(:point) { Geocoding.point(latitude: 0, longitude: 0) }

      it 'orders branches by markup rate in ascending order' do
        expect(search_result).to eq([branch_of_cheaper_supplier, branch_of_costlier_supplier])
      end
    end

    context 'when there are suppliers with different rates in different locations' do
      let!(:branch_of_cheapest_supplier) do
        supplier_framework = create(:supplier_framework, framework_id:)
        supplier_framework_lot = create(:supplier_framework_lot, supplier_framework:, lot_id:)

        create(:supplier_framework_lot_rate, supplier_framework_lot: supplier_framework_lot, position_id: position_id, rate: 0)

        create(
          :supplier_framework_lot_branch,
          supplier_framework_lot: supplier_framework_lot,
          location: Geocoding.point(latitude: 0.2, longitude: 0.2)
        )
      end
      let!(:branch_of_farthest_supplier) do
        supplier_framework = create(:supplier_framework, framework_id:)
        supplier_framework_lot = create(:supplier_framework_lot, supplier_framework:, lot_id:)

        create(:supplier_framework_lot_rate, supplier_framework_lot: supplier_framework_lot, position_id: position_id, rate: 1000)

        create(
          :supplier_framework_lot_branch,
          supplier_framework_lot: supplier_framework_lot,
          location: Geocoding.point(latitude: 0.1, longitude: 0.1)
        )
      end
      let!(:branch_of_closest_supplier) do
        supplier_framework = create(:supplier_framework, framework_id:)
        supplier_framework_lot = create(:supplier_framework_lot, supplier_framework:, lot_id:)

        create(:supplier_framework_lot_rate, supplier_framework_lot: supplier_framework_lot, position_id: position_id, rate: 1000)

        create(
          :supplier_framework_lot_branch,
          supplier_framework_lot: supplier_framework_lot,
          location: Geocoding.point(latitude: 0, longitude: 0)
        )
      end

      let(:point) { Geocoding.point(latitude: 0, longitude: 0) }

      it 'orders branches by mark-up and then proximity in ascending order' do
        expect(search_result).to eq([branch_of_cheapest_supplier, branch_of_closest_supplier, branch_of_farthest_supplier])
      end
    end
  end

  describe '.address_elements' do
    let(:result) { supplier_framework_lot_branch.address_elements }

    before do
      supplier_framework_lot_branch.update(
        address_line_1: 'The first address line',
        address_line_2: address_line_2,
        town: 'The town',
        county: county,
        postcode: 'postcode'
      )
    end

    context 'when all elements are present' do
      let(:address_line_2) { 'The second address line' }
      let(:county) { 'The county' }

      it 'returns all the elemements' do
        expect(result).to eq [
          'The first address line',
          'The second address line',
          'The town',
          'The county',
          'postcode'
        ]
      end
    end

    context 'when some elements are present' do
      let(:address_line_2) { '' }
      let(:county) { nil }

      it 'returns just the present elements' do
        expect(result).to eq [
          'The first address line',
          'The town',
          'postcode'
        ]
      end
    end
  end
end
