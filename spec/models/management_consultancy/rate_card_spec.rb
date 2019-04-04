require 'rails_helper'

RSpec.describe ManagementConsultancy::RateCard, type: :model do
  subject(:rate_card) { build(:management_consultancy_rate_card) }

  it { is_expected.to be_valid }

  describe '.average_daily_rate' do
    it 'is expected to output the correct average' do
      expect(rate_card.average_daily_rate).to eq(35)
    end
  end
end
