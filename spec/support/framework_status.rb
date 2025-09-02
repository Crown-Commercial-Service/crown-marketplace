RSpec.shared_context 'and RM6238 is live in the future' do
  before { Framework.find('RM6238').update(live_at: 1.day.from_now) }
end

RSpec.shared_context 'and RM6238 is live today' do
  before { Framework.find('RM6238').update(live_at: Time.zone.now) }
end

RSpec.shared_context 'and RM6238 has expired' do
  before { Framework.find('RM6238').update(expires_at: Time.zone.now) }
end

RSpec.shared_context 'and RM6240 is live in the future' do
  before { Framework.find('RM6240').update(live_at: 1.day.from_now) }
end

RSpec.shared_context 'and RM6240 is live today' do
  before { Framework.find('RM6240').update(live_at: Time.zone.now) }
end

RSpec.shared_context 'and RM6240 has expired' do
  before { Framework.find('RM6240').update(expires_at: Time.zone.now) }
end

RSpec.shared_context 'and RM6187 is live' do
  before { Framework.find('RM6187').update(expires_at: 1.day.from_now) }
end

RSpec.shared_context 'and RM6187 has expired' do
  before { Framework.find('RM6187').update(expires_at: Time.zone.now) }
end

RSpec.shared_context 'and RM6309 is live in the future' do
  before { Framework.find('RM6309').update(live_at: 1.day.from_now) }
end

RSpec.shared_context 'and RM6309 is live today' do
  before { Framework.find('RM6309').update(live_at: Time.zone.now) }
end

RSpec.shared_context 'and RM6309 has expired' do
  before { Framework.find('RM6309').update(expires_at: Time.zone.now) }
end

RSpec.shared_context 'and RM6360 is live in the future' do
  before { Framework.find('RM6360').update(live_at: 1.day.from_now) }
end

RSpec.shared_context 'and RM6360 is live today' do
  before { Framework.find('RM6360').update(live_at: Time.zone.now) }
end

RSpec.shared_context 'and RM6360 has expired' do
  before { Framework.find('RM6360').update(expires_at: Time.zone.now) }
end

RSpec.shared_context 'and RM6232 is live in the future' do
  before { Framework.find('RM6232').update(live_at: 1.day.from_now) }
end

RSpec.shared_context 'and RM6232 is live today' do
  before { Framework.find('RM6232').update(live_at: Time.zone.now) }
end

RSpec.shared_context 'and RM6232 has expired' do
  before { Framework.find('RM6232').update(expires_at: Time.zone.now) }
end

RSpec.shared_context 'and RM3830 is live' do
  before { Framework.find('RM3830').update(expires_at: 1.day.from_now) }
end
