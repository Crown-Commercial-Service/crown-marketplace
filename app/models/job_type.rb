class JobType
  include ActiveModel::Model

  attr_accessor :code, :description

  def self.all
    @all ||= []
  end

  def self.find_by(arg)
    all.find { |term| arg.all? { |k, v| term.public_send(k) == v } }
  end
end

JobType.all.replace [
  JobType.new(
    code: 'qt',
    description: 'Qualified teacher: Non-SEN roles'
  ),
  JobType.new(
    code: 'qt_sen',
    description: 'Qualified teacher: SEN roles'
  ),
  JobType.new(
    code: 'uqt',
    description: 'Unqualified teacher: Non-SEN roles'
  ),
  JobType.new(
    code: 'uqt_sen',
    description: 'Unqualified teacher: SEN roles'
  ),
  JobType.new(
    code: 'support',
    description: 'Educational support staff: Non-SEN roles (incl. cover supervisor and teaching assistant)'
  ),
  JobType.new(
    code: 'support_sen',
    description: 'Educational support staff: SEN roles (incl. cover supervisor and teaching assistant)'
  ),
  JobType.new(
    code: 'senior',
    description: 'Other roles: headteacher and senior leadership positions'
  ),
  JobType.new(
    code: 'admin',
    description: 'Other roles: admin & clerical staff, IT staff, finance staff, cleaners, etc.'
  )
]
