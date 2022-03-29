RSpec.shared_context 'and RM6232 is not live' do
  before { FacilitiesManagement::Framework.find_by(framework: 'RM6232').update(live_at: Time.zone.now + 1.day) }
end

RSpec.shared_context 'and RM3830 is not live' do
  before { FacilitiesManagement::Framework.find_by(framework: 'RM3830').update(live_at: Time.zone.now + 1.day) }
end
