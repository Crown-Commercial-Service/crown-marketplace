require 'rails_helper'

module ManagementConsultancy
  RSpec.describe Supplier, type: :model do
    subject(:supplier) { build(:management_consultancy_supplier) }

    it { is_expected.to be_valid }

    it 'is not valid if name is blank' do
      supplier.name = ''
      expect(supplier).not_to be_valid
    end
  end
end
