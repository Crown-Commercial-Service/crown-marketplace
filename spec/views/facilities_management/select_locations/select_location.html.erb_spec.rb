require 'rails_helper'
RSpec.describe 'facilities_management/select_locations/select_location.html.erb', type: :view do
  it 'Gets regions' do
    h = {}
    Nuts1Region.all.each { |x| h[x.code] = x.name }
    assert(!h.empty?)
  end

  it 'gets subregions' do
    h = {}
    FacilitiesManagement::Region.all.each { |x| h[x.code] = x.name }
    assert(!h.empty?)
  end
end
