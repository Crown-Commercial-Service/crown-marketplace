require 'rails_helper'

RSpec.describe ManagementConsultancy::RateCard, type: :model do
  subject(:rate_card) { build(:management_consultancy_rate_card) }

  it { is_expected.to be_valid }
end
