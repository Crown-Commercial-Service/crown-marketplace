require 'rails_helper'

RSpec.describe CCS::FM::Service, type: :model do
  it 'FC contains an example service' do
    expect((CCS::FM::Service.further_competition_services.include? 'C.5')).to be true
  end

  it 'DA contains an example service' do
    expect((CCS::FM::Service.direct_award_services.include? 'A.6')).to be true
  end
end
