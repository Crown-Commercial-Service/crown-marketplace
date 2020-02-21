require 'rails_helper'

RSpec.describe CCS::FM::Service, type: :model do
  it 'FC contains an example service' do
    expect((described_class.further_competition_services.include? 'C.5')).to be true
  end

  it 'DA contains an example service' do
    expect((described_class.direct_award_services.include? 'A.6')).to be true
  end
end
