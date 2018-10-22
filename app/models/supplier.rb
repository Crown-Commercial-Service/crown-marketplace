class Supplier < ApplicationRecord
  has_many :branches, dependent: :destroy
  has_many :rates, dependent: :destroy

  validates :name, presence: true

  def self.with_master_vendor_rates
    Rate.includes(:supplier).master_vendor.map(&:supplier).uniq
  end

  def nominated_worker_rate
    return nil if scoped_rates.nominated_worker.first.blank?

    scoped_rates.nominated_worker.first.mark_up
  end

  def fixed_term_rate
    return nil if scoped_rates.fixed_term.first.blank?

    scoped_rates.fixed_term.first.mark_up
  end

  def master_vendor_rates_grouped_by_job_type
    rates.master_vendor.group_by(&:job_type)
  end

  def scoped_rates
    rates.direct_provision
  end
end
