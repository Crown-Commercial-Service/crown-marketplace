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

  it 'is not valid if supplier has another rate for this job type and term' do
    rate.term = 'one_week'
    rate.save!
    new_rate = build(
      :rate,
      supplier: rate.supplier,
      job_type: rate.job_type,
      term: rate.term
    )
    expect(new_rate).not_to be_valid
  end

  it 'is valid if supplier has another rate for this job type but different term' do
    rate.term = 'one_week'
    rate.save!
    new_rate = build(
      :rate,
      supplier: rate.supplier,
      job_type: rate.job_type,
      term: 'one_month'
    )
    expect(new_rate).to be_valid
  end

  it 'is not valid if job type is not in the list of acceptable types' do
    rate.job_type = 'made-up-job-type'
    expect(rate).not_to be_valid
  end
end
