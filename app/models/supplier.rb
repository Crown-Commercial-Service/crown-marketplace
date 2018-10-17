class Supplier < ApplicationRecord
  has_many :branches, dependent: :destroy
  has_many :rates, dependent: :destroy

  validates :name, presence: true

  def nominated_worker_rate
    return nil if rates.nominated_worker.first.blank?

    rates.nominated_worker.first.mark_up
  end

  def fixed_term_rate
    return nil if rates.fixed_term.first.blank?

    rates.fixed_term.first.mark_up
  end
end
