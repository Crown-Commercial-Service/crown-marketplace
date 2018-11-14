require 'rails_helper'

module SupplyTeachers
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

    context "when it's a percentage mark-up" do
      before do
        rate.job_type = 'nominated'
        rate.mark_up = 1
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
        rate.job_type = 'daily_fee'
        rate.daily_fee = 1
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
end
