require 'rails_helper'

RSpec.describe CCS::FM::Service, type: :model do
  it 'FC contains an example service' do
    expect((described_class.further_competition_services('123').include? 'C.5')).to be true
  end

  it 'DA contains an example service' do
    expect((described_class.direct_award_services('123').include? 'C.1')).to be true
  end

  it 'DA contains an example service using a frozen rate' do
    user = create(:user)
    procurement = create(:facilities_management_procurement, user: user)

    frozen_rate = CCS::FM::FrozenRate.new(facilities_management_procurement_id: procurement.id, code: 'C.1', framework: 1.2, benchmark: 2.2, standard: 'Y', direct_award: true)
    frozen_rate.save!
    expect((described_class.direct_award_services(procurement.id).include? 'C.1')).to be true
  end
end
