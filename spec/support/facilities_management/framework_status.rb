RSpec.shared_context 'and RM6232 is not live' do
  before { FacilitiesManagement::Framework.find_by(framework: 'RM6232').update(live_at: 1.day.from_now) }
end

RSpec.shared_context 'and RM3830 is not live' do
  before { FacilitiesManagement::Framework.find_by(framework: 'RM3830').update(live_at: 1.day.from_now) }
end
