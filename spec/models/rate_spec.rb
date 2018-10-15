require 'rails_helper'

RSpec.describe Rate, type: :model do
  subject(:rate) { build(:rate) }

  it { is_expected.to be_valid }

  it 'is not valid if job_type is blank' do
    rate.job_type = ''
    expect(rate).not_to be_valid
  end

  it 'is not valid if mark_up is blank' do
    rate.mark_up = nil
    expect(rate).not_to be_valid
  end
end
