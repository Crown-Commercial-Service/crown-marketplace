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

  it 'is not valid if another rate for this job type from this supplier already exists' do
    rate.save!
    new_rate = build(:rate, supplier: rate.supplier, job_type: rate.job_type)
    expect(new_rate).not_to be_valid
  end
end
