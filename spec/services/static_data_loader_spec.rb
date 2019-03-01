require 'rails_helper'

RSpec.describe StaticDataLoader do

    # static_data_loader
    
    #  StaticDataLoader.load_static_data(Region)
    describe '.regions_not_empty' do
        it 'there are more than zero Regions?' do
            expect(Region.static_data_class.all.count.zero?).to be(false)
        end
    end

    # StaticDataLoader.load_static_data(Nuts1Region)
    describe '.nuts1_codes_not_empty' do
        it 'there are more than zero Nuts1 Regions?' do
            expect(Nuts1Region.all.count.zero?).to be(false)
        end
    end

    # StaticDataLoader.load_static_data(Nuts2Region)
    describe '.nuts2_codes_not_empty' do
        it 'there are more than zero Nuts2 Regions?' do
            expect(Nuts2Region.all.count.zero?).to be(false)
        end
    end

    # StaticDataLoader.load_static_data(Nuts3Region)
    describe '.nuts3_codes_not_empty' do
        it 'there are more than zero Nuts3 Regions?' do
            expect(Nuts3Region.all.count.zero?).to be(false)
        end
    end

end