require 'rails_helper'

RSpec.describe Rate, type: :model do
  subject(:rate) { build(:rate) }

  it { is_expected.to be_valid }

  it 'is not valid if lot_number is blank' do
    rate.lot_number = nil
    expect(rate).not_to be_valid
  end

  it 'is not valid if job_type is blank' do
    rate.job_type = ''
    expect(rate).not_to be_valid
  end

  it 'is not valid if mark_up is blank' do
    rate.mark_up = nil
    expect(rate).not_to be_valid
  end

  it 'is not valid if supplier has another rate for this job type, lot_number and term' do
    rate.term = 'one_week'
    rate.save!
    new_rate = build(
      :rate,
      supplier: rate.supplier,
      job_type: rate.job_type,
      lot_number: rate.lot_number,
      term: rate.term
    )
    expect(new_rate).not_to be_valid
  end

  it 'is valid if supplier has another rate for this job type and lot_number, but different term' do
    rate.term = 'one_week'
    rate.save!
    new_rate = build(
      :rate,
      supplier: rate.supplier,
      job_type: rate.job_type,
      lot_number: rate.lot_number,
      term: 'one_month'
    )
    expect(new_rate).to be_valid
  end

  it 'is valid if different supplier has another rate for this job type, lot_number and term' do
    rate.term = 'one_week'
    rate.save!
    new_rate = build(
      :rate,
      supplier: build(:supplier),
      job_type: rate.job_type,
      lot_number: rate.lot_number,
      term: rate.term
    )
    expect(new_rate).to be_valid
  end

  it 'is valid if supplier has another rate for this job type and term, but different lot_number' do
    rate.term = 'one_week'
    rate.save!
    new_rate = build(
      :rate,
      supplier: rate.supplier,
      job_type: rate.job_type,
      lot_number: rate.lot_number + 1,
      term: rate.term
    )
    expect(new_rate).to be_valid
  end

  it 'is not valid if job type is not in the list of acceptable types' do
    rate.job_type = 'made-up-job-type'
    expect(rate).not_to be_valid
  end
end
