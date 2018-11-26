module SupplyTeachers
  class Rate < ApplicationRecord
    LOT_NUMBERS = {
      1 => 'Direct provision',
      2 => 'Master vendor',
      3 => 'Neutral vendor'
    }.freeze

    JOB_TYPES = {
      'qt' => 'Qualified teacher: non-SEN roles',
      'qt_sen' => 'Qualified teacher: SEN roles',
      'uqt' => 'Unqualified teacher: non-SEN roles',
      'uqt_sen' => 'Unqualified teacher: SEN roles',
      'support' => 'Educational support staff: non-SEN roles (including cover supervisor and teaching assistant)',
      'support_sen' => 'Educational support staff: SEN roles (including cover supervisor and teaching assistant)',
      'senior' => 'Headteacher and senior leadership positions',
      'admin' => 'Administrative and clerical staff, IT staff, finance staff and cleaners',
      'nominated' => 'A specific person',
      'fixed_term' => 'Employed directly',
      'daily_fee' => 'Neutral vendor managed service provider fee (per day)'
    }.freeze

    TERMS = {
      'one_week' => 'Up to 1 week',
      'twelve_weeks' => '1 to 12 weeks',
      'more_than_twelve_weeks' => 'Over 12 weeks'
    }.freeze

    belongs_to :supplier,
               foreign_key: :supply_teachers_supplier_id,
               inverse_of: :branches

    validates :lot_number, presence: true,
                           uniqueness: { scope: %i[supplier term job_type] },
                           inclusion: { in: LOT_NUMBERS.keys }

    validates :job_type, presence: true,
                         uniqueness: { scope: %i[supplier term lot_number] },
                         inclusion: { in: JOB_TYPES.keys }

    validates :mark_up,
              presence: { if: :percentage_mark_up? },
              absence: { unless: :percentage_mark_up? }

    validates :daily_fee,
              presence: { if: :daily_fee? },
              absence: { unless: :daily_fee? }

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

    def daily_fee?
      job_type == 'daily_fee'
    end

    def percentage_mark_up?
      !daily_fee?
    end
  end
end
