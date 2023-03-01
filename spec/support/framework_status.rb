RSpec.shared_context 'and RM6232 is live in the future' do
  before { Framework.find_by(framework: 'RM6232').update(live_at: 1.day.from_now) }
end

RSpec.shared_context 'and RM6232 is live today' do
  before { Framework.find_by(framework: 'RM6232').update(live_at: Time.zone.now) }
end

RSpec.shared_context 'and RM6232 has expired' do
  before { Framework.find_by(framework: 'RM6232').update(expires_at: Time.zone.now) }
end

RSpec.shared_context 'and RM3830 has expired' do
  before { Framework.find_by(framework: 'RM3830').update(expires_at: Time.zone.now) }
end
