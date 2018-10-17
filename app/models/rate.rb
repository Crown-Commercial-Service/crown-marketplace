class Rate < ApplicationRecord
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

  belongs_to :supplier

  validates :job_type, presence: true,
                       uniqueness: { scope: %i[supplier term] },
                       inclusion: { in: JOB_TYPES.keys }
  validates :mark_up, presence: true

  def self.nominated_worker
    where(job_type: 'nominated')
  end

  def self.fixed_term
    where(job_type: 'fixed_term')
  end
end
