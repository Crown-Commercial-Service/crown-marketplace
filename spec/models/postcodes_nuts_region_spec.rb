require 'rails_helper'

RSpec.describe PostcodesNutsRegion do
  it 'Create a record' do
    postcode_nuts_save_record = described_class.new(postcode: 'AB101AB', code: 'UKM50').save
    expect(postcode_nuts_save_record).to be(true)
  end

  it 'Get a record' do
    postcode_nuts_save_record = described_class.new(postcode: 'AB101AB', code: 'UKM50').save
    expect(postcode_nuts_save_record).to be(true)
    get_postcode_record = described_class.find_by(postcode: 'AB101AB')
    expect(get_postcode_record).to have_attributes(postcode: 'AB101AB', code: 'UKM50')
  end
end
