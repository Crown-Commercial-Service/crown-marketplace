class Supplier < ApplicationRecord
  has_many :branches, dependent: :destroy
  has_many :rates, dependent: :destroy

  validates :name, presence: true

  def nominated_worker_rate
    return nil if rates.nominated_worker.first.blank?

    rates.nominated_worker.first.mark_up
  end
end
