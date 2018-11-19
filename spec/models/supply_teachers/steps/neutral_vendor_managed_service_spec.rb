require 'rails_helper'

RSpec.describe SupplyTeachers::Steps::NeutralVendorManagedService, type: :model do
  subject(:results) do
    described_class.new
  end

  it 'describes its inputs' do
    expect(results.inputs).to eq(
      looking_for: 'Managed service provider',
      managed_service_provider: 'Neutral vendor'
    )
  end
end
