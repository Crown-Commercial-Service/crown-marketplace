require 'rails_helper'

RSpec.describe Branch, type: :model do
  subject(:branch) { build(:branch) }

  it { is_expected.to be_valid }

  it 'is not valid if postcode is blank' do
    branch.postcode = ''
    expect(branch).not_to be_valid
  end

  it 'is not valid if location is blank' do
    branch.location = nil
    expect(branch).not_to be_valid
  end

  it 'is not valid if telephone_number is blank' do
    branch.telephone_number = ''
    expect(branch).not_to be_valid
  end

  it 'is not valid if contact_name is blank' do
    branch.contact_name = ''
    expect(branch).not_to be_valid
  end

  it 'is not valid if contact_email is blank' do
    branch.contact_email = ''
    expect(branch).not_to be_valid
  end

  context 'when postcode is nonsense' do
    before do
      branch.postcode = 'nonsense'
    end

    it { is_expected.not_to be_valid }

    it 'has a sensible error message' do
      branch.validate
      expect(branch.errors).to include(postcode: include('is not a valid postcode'))
    end
  end

  describe '.near' do
    context 'when three branches exist in different locations' do
      let!(:london_1) do
        create(
          :branch,
          location: Geocoding.point(latitude: 51.5201, longitude: -0.0759)
        )
      end
      let!(:london_2) do
        create(
          :branch,
          location: Geocoding.point(latitude: 51.5263, longitude: -0.0858)
        )
      end
      let!(:edinburgh) do
        create(
          :branch,
          location: Geocoding.point(latitude: 55.9619, longitude: -3.1953)
        )
      end

      let(:shoreditch) { Geocoding.point(latitude: 51.5255, longitude: -0.0587) }

      it 'includes nearby branches' do
        expect(Branch.near(shoreditch, within_metres: 10000)).to include(london_1, london_2)
      end

      it 'excludes far away branches' do
        expect(Branch.near(shoreditch, within_metres: 10000)).not_to include(edinburgh)
      end
    end
  end

  describe '.search' do
    context 'when there are branches outside of the search area' do
      let(:supplier) do
        create(:supplier).tap do |s|
          create(:rate, job_type: 'nominated', supplier: s)
        end
      end
      let!(:branch_within_search_area) do
        create(:branch, supplier: supplier, location: Geocoding.point(latitude: 51.5172265, longitude: -0.1275961))
      end
      let!(:branch_outside_search_area) do
        create(:branch, supplier: supplier, location: Geocoding.point(latitude: 50.7230521, longitude: -2.0430911))
      end
      let(:results) { Branch.search(Geocoding.point(latitude: 51.5, longitude: 0)).to_a }

      it 'includes branches within 25 miles' do
        expect(results).to include(branch_within_search_area)
      end

      it 'excludes branches outside 25 miles' do
        expect(results).not_to include(branch_outside_search_area)
      end
    end

    context 'when there are suppliers without nominated worker rates' do
      let!(:branch_with_nominated_worker_rates) do
        supplier = create(:supplier)
        create(:rate, job_type: 'nominated', supplier: supplier)
        create(:branch,
               supplier: supplier,
               location: Geocoding.point(latitude: 0, longitude: 0))
      end
      let!(:branch_with_no_nominated_worker_rates) do
        supplier = create(:supplier)
        create(:branch,
               supplier: supplier,
               location: Geocoding.point(latitude: 0, longitude: 0))
      end
      let(:results) { Branch.search(Geocoding.point(latitude: 0, longitude: 0)).to_a }

      it 'includes suppliers that have nominated worker rates' do
        expect(results).to include(branch_with_nominated_worker_rates)
      end

      it "excludes suppliers that don't have nominated worker rates" do
        expect(results).not_to include(branch_with_no_nominated_worker_rates)
      end
    end

    context 'when there are suppliers with fixed term rates' do
      let!(:branch_with_fixed_term_rates) do
        supplier = create(:supplier)
        create(:rate, job_type: 'fixed_term', supplier: supplier)
        create(:branch,
               supplier: supplier,
               location: Geocoding.point(latitude: 0, longitude: 0))
      end
      let!(:branch_with_no_fixed_term_rates) do
        supplier = create(:supplier)
        create(:branch,
               supplier: supplier,
               location: Geocoding.point(latitude: 0, longitude: 0))
      end
      let(:results) do
        point = Geocoding.point(latitude: 0, longitude: 0)
        Branch.search(point, fixed_term: true).to_a
      end

      it 'includes suppliers that have fixed term rates' do
        expect(results).to include(branch_with_fixed_term_rates)
      end

      it "excludes suppliers that don't have fixed term rates" do
        expect(results).not_to include(branch_with_no_fixed_term_rates)
      end
    end

    context 'when there are suppliers with different nominated worker rates' do
      let!(:branch_of_cheaper_supplier) do
        supplier = create(:supplier)
        create(:rate, job_type: 'nominated', supplier: supplier, mark_up: 0.1)
        create(:branch, supplier: supplier, location: Geocoding.point(latitude: 0, longitude: 0))
      end
      let!(:branch_of_costlier_supplier) do
        supplier = create(:supplier)
        create(:rate, job_type: 'nominated', supplier: supplier, mark_up: 0.9)
        create(:branch, supplier: supplier, location: Geocoding.point(latitude: 0, longitude: 0))
      end

      it 'orders branches by markup rate in ascending order' do
        results = Branch.search(Geocoding.point(latitude: 0, longitude: 0)).to_a
        expect(results).to eq([branch_of_cheaper_supplier, branch_of_costlier_supplier])
      end
    end
  end
end
