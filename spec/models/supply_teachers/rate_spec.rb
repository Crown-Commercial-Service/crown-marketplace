require 'rails_helper'

RSpec.describe SupplyTeachers::Rate, type: :model do
  subject(:rate) { build(:supply_teachers_rate) }

  it { is_expected.to be_valid }

  it 'is not valid if lot_number is blank' do
    rate.lot_number = nil
    expect(rate).not_to be_valid
  end

  it 'is not valid if lot_number is not in list of all lot numbers' do
    rate.lot_number = 'invalid-number'
    expect(rate).not_to be_valid
    expect(rate.errors[:lot_number]).to include('is not included in the list')
  end

  it 'is not valid if job_type is blank' do
    rate.job_type = ''
    expect(rate).not_to be_valid
  end

  it 'is not valid if job_type is not in list of all job types' do
    rate.job_type = 'invalid-job-type'
    expect(rate).not_to be_valid
    expect(rate.errors[:job_type]).to include('is not included in the list')
  end

  it 'is valid if term is blank and job type is fixed term' do
    rate.assign_attributes(term: '', job_type: 'fixed_term')
    expect(rate).to be_valid
  end

  it 'is valid if term is blank and job type is nominated' do
    rate.assign_attributes(term: '', job_type: 'nominated')
    expect(rate).to be_valid
  end

  it 'is valid if term is blank and job type is daily_fee' do
    rate.assign_attributes(term: '', job_type: 'daily_fee', daily_fee: 100, mark_up: nil)
    expect(rate).to be_valid
  end

  it 'is not valid if term is not blank and job type is fixed term' do
    rate.assign_attributes(term: 'one_week', job_type: 'fixed_term')
    expect(rate).not_to be_valid
  end

  it 'is not valid if term is not blank and job type is nominated' do
    rate.assign_attributes(term: 'one_week', job_type: 'nominated')
    expect(rate).not_to be_valid
  end

  it 'is not valid if term is not blank and job type is daily_fee' do
    rate.assign_attributes(term: 'one_week', job_type: 'daily_fee')
    expect(rate).not_to be_valid
  end

  it 'is valid if term is not blank and job type is not fixed term, nominated or daily fee' do
    rate.assign_attributes(term: 'one_week', job_type: 'admin')
    expect(rate).to be_valid
  end

  it 'is not valid if term is blank and job type is not fixed term, nominated or daily fee' do
    rate.assign_attributes(term: '', job_type: 'admin')
    expect(rate).not_to be_valid
  end

  it 'is not valid if term is not in list of all rate terms' do
    rate.assign_attributes(term: 'invalid-rate-term', job_type: 'admin')
    expect(rate).not_to be_valid
    expect(rate.errors[:term]).to include('is not included in the list')
  end

  context "when it's a percentage mark up" do
    before do
      rate.assign_attributes(job_type: 'nominated', mark_up: 1)
    end

    it '#daily_fee? is false' do
      expect(rate).not_to be_daily_fee
    end

    it '#percentage_mark_up? is true' do
      expect(rate).to be_percentage_mark_up
    end

    it 'is not valid if mark_up is blank' do
      rate.mark_up = nil
      expect(rate).not_to be_valid
      expect(rate.errors[:mark_up]).to include("can't be blank")
    end

    it 'is not valid if daily_fee is present' do
      rate.daily_fee = 1
      expect(rate).not_to be_valid
    end
  end

  context "when it's a daily fee" do
    before do
      rate.assign_attributes(job_type: 'daily_fee', daily_fee: 1)
    end

    it '#daily_fee? is true' do
      expect(rate).to be_daily_fee
    end

    it '#percentage_mark_up? is false' do
      expect(rate).not_to be_percentage_mark_up
    end

    it 'is not valid if daily_fee is blank' do
      rate.daily_fee = nil
      expect(rate).not_to be_valid
      expect(rate.errors[:daily_fee]).to include("can't be blank")
    end

    it 'is not valid if mark_up is present' do
      rate.mark_up = 1
      expect(rate).not_to be_valid
    end
  end

  it 'is not valid if supplier has another rate for this job type, lot_number and term' do
    rate.update!(job_type: 'admin', term: 'one_week')
    new_rate = build(
      :supply_teachers_rate,
      supplier: rate.supplier,
      job_type: rate.job_type,
      lot_number: rate.lot_number,
      term: rate.term
    )
    expect(new_rate).not_to be_valid
  end

  it 'is valid if supplier has another rate for this job type and lot_number, but different term' do
    rate.update!(job_type: 'admin', term: 'one_week')
    new_rate = build(
      :supply_teachers_rate,
      supplier: rate.supplier,
      job_type: rate.job_type,
      lot_number: rate.lot_number,
      term: 'twelve_weeks'
    )
    expect(new_rate).to be_valid
  end

  it 'is valid if different supplier has another rate for this job type, lot_number and term' do
    rate.update!(job_type: 'admin', term: 'one_week')
    new_rate = build(
      :supply_teachers_rate,
      supplier: build(:supply_teachers_supplier),
      job_type: rate.job_type,
      lot_number: rate.lot_number,
      term: rate.term
    )
    expect(new_rate).to be_valid
  end

  it 'is valid if supplier has another rate for this job type and term, but different lot_number' do
    rate.update!(job_type: 'admin', term: 'one_week')
    new_rate = build(
      :supply_teachers_rate,
      supplier: rate.supplier,
      job_type: rate.job_type,
      lot_number: rate.lot_number + 1,
      term: rate.term
    )
    expect(new_rate).to be_valid
  end
end
