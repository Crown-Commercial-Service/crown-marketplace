require 'rails_helper'

RSpec.describe CCS::FM::Building, type: :model do
  let(:building) do
    { 'id' => nil,
      'name' => 'ccs', 'region' => 'London',
      'address' => { 'fm-address-postcode' => 'SW1W 9SZ',
                     'fm-address-line-1' => 'ccs',
                     'fm-address-line-2' => '151 Buckingham Palace Road',
                     'fm-address-town' => 'London',
                     'fm-address-county' => 'London' },
      'isLondon' => 'Yes',
      'gia' => 12345 }
  end

  it 'can create a new building' do
    id = SecureRandom.uuid
    building['id'] = id

    email_address = 'test@example.com'

    b = CCS::FM::Building.create(id: building['id'],
                                 user_id: Base64.encode64(email_address),
                                 updated_by: Base64.encode64(email_address),
                                 building_json: building)

    expect(b.building_json['id']).to eq id
  end
end
