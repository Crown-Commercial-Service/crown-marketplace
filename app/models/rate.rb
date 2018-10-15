class Rate < ApplicationRecord
  belongs_to :supplier

  validates :job_type, presence: true
  validates :mark_up, presence: true

  def self.nominated_worker
    where(job_type: 'nominated')
  end
end
