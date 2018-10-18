class Rate < ApplicationRecord
  LOT_NUMBERS = {
    1 => 'Direct provision',
    2 => 'Master vendor',
    3 => 'Neutral vendor'
  }.freeze

  JOB_TYPES = {
    'qt' => 'Qualified Teacher - Non-SEN',
    'qt_sen' => 'Qualified Teacher - SEN',
    'uqt' => 'Unqualified Teacher - Non-SEN',
    'uqt_sen' => 'Unqualified Teacher - SEN',
    'support' => 'Support staff - Non-SEN',
    'support_sen' => 'Support staff - SEN',
    'senior' => 'Senior leadership staff',
    'admin' => 'Clerical staff',
    'nominated' => 'Nominated workers',
    'fixed_term' => 'Fixed Term workers'
  }.freeze

  TERMS = {
    'one_week' => 'Up to 1 week',
    'twelve_weeks' => '1 week to 12 weeks',
    'more_than_twelve_weeks' => 'Over 12 weeks'
  }.freeze

  belongs_to :supplier

  validates :lot_number, presence: true,
                         uniqueness: { scope: %i[supplier term job_type] },
                         inclusion: { in: LOT_NUMBERS.keys }

  validates :job_type, presence: true,
                       uniqueness: { scope: %i[supplier term lot_number] },
                       inclusion: { in: JOB_TYPES.keys }

  validates :mark_up, presence: true

  def self.nominated_worker
    where(job_type: 'nominated')
  end

  def self.fixed_term
    where(job_type: 'fixed_term')
  end

  def self.direct_provision
    where(lot_number: 1)
  end

  def self.master_vendor
    where(lot_number: 2)
  end

  def self.neutral_vendor
    where(lot_number: 3)
  end

  def self.rate_for(job_type:, term:)
    where(job_type: job_type.code, term: term.rate_term)
  end
end
