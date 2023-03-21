require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::Supplier::SupplierRatesHelper do
  describe 'Supplier rates helper tests' do
    context 'with rates in work_packages as sub array' do
      it 'Will return a rates array' do
        rates_list = [
          { code: 'P.1', framework: '4.817413254', benchmark: '2.664327543', standard: 'A' },
          { code: 'P.2', framework: '4.817413254', benchmark: '2.664327543', standard: 'B' }
        ]

        work_packages = [
          { code: 'P.1', has_standards: true, work_package_code: 'P' },
          { code: 'P.2', has_standards: true, work_package_code: 'P' }
        ]
        work_packages_with_rates = described_class.add_rates_to_work_packages(work_packages, rates_list)
        expect(work_packages_with_rates[0]['rates']).to be_an_instance_of(Array)
      end
    end
  end
end
