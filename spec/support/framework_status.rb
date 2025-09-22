%w[RM6238 RM6240 RM6309 RM6360 RM6378].each do |framework_id|
  RSpec.shared_context "and #{framework_id} is live in the future" do
    before { Framework.find(framework_id).update(live_at: 1.day.from_now) }
  end

  RSpec.shared_context "and #{framework_id} is live today" do
    before { Framework.find(framework_id).update(live_at: Time.zone.now) }
  end

  RSpec.shared_context "and #{framework_id} has expired" do
    before { Framework.find(framework_id).update(expires_at: Time.zone.now) }
  end
end

%w[RM6187 RM3830 RM6232].each do |framework_id|
  RSpec.shared_context "and #{framework_id} is live" do
    before { Framework.find(framework_id).update(expires_at: 1.day.from_now) }
  end
end
