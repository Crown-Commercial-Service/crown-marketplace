module SupplyTeachers
  class Supplier < ApplicationRecord
    has_many :branches,
             foreign_key: :supply_teachers_supplier_id,
             inverse_of: :supplier,
             dependent: :destroy
    has_many :rates,
             foreign_key: :supply_teachers_supplier_id,
             inverse_of: :supplier,
             dependent: :destroy

    validates :name, presence: true

    def self.with_master_vendor_rates
      Rate.includes(:supplier).master_vendor.map(&:supplier).uniq
    end

    def self.with_neutral_vendor_rates
      Rate.includes(:supplier).neutral_vendor.map(&:supplier).uniq
    end

    def nominated_worker_rate
      return nil if scoped_rates.nominated_worker.first.blank?

      scoped_rates.nominated_worker.first.mark_up
    end

    def fixed_term_rate
      return nil if scoped_rates.fixed_term.first.blank?

      scoped_rates.fixed_term.first.mark_up
    end

    def rate_for(job_type:, term:)
      scoped_rates.rate_for(job_type: job_type, term: term).first&.mark_up
    end

    def master_vendor_rates_grouped_by_job_type
      rates.master_vendor.group_by(&:job_type)
    end

    def scoped_rates
      rates.direct_provision
    end
  end
end
