module SupplyTeachers
  class Rate < ApplicationRecord
    belongs_to :supplier,
               foreign_key: :supply_teachers_supplier_id,
               inverse_of: :branches

    validates :lot_number, presence: true,
                           uniqueness: { scope: %i[supplier term job_type] },
                           inclusion: { in: Lot.all_numbers }

    validates :job_type, presence: true,
                         uniqueness: { scope: %i[supplier term lot_number] },
                         inclusion: { in: JobType.all_codes }

    validates :term,
              presence: { if: :term_required? },
              absence: { unless: :term_required? },
              inclusion: { in: RateTerm.all_codes, allow_blank: true }

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

    def term_required?
      !%w[nominated fixed_term daily_fee].include?(job_type)
    end
  end
end
