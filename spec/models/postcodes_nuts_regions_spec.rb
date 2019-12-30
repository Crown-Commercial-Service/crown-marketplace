require 'rails_helper'

RSpec.describe PostcodesNutsRegions, type: :model do
    context 'Postcode Nuts tests' do 
        it 'Create a record' do 
            postcode_nuts_save_record = PostcodesNutsRegions.new(postcode:'AB101AB', code:'UKM50').save
            expect(postcode_nuts_save_record).to eq(true)
        end
        it 'Get a record' do 
            postcode_nuts_save_record = PostcodesNutsRegions.new(postcode:'AB101AB', code:'UKM50').save
            get_postcode_record = PostcodesNutsRegions.find_by(postcode:'AB101AB')
            expect(get_postcode_record).to have_attributes(postcode: 'AB101AB', code:'UKM50')
        end
    end
end