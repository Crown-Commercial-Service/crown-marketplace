class JobType
  include StaticRecord

  attr_accessor :code, :description
end

JobType.define(
  %i[code description],
  [
    ['qt',          'Qualified teacher: Non-SEN roles'],
    ['qt_sen',      'Qualified teacher: SEN roles'],
    ['uqt',         'Unqualified teacher: Non-SEN roles'],
    ['uqt_sen',     'Unqualified teacher: SEN roles'],
    ['support',     'Educational support staff: Non-SEN roles '\
                    '(incl. cover supervisor and teaching assistant)'],
    ['support_sen', 'Educational support staff: SEN roles '\
                    '(incl. cover supervisor and teaching assistant)'],
    ['senior',      'Other roles: headteacher and senior leadership positions'],
    ['admin',       'Other roles: admin & clerical staff, IT staff, '\
                    'finance staff, cleaners, etc.']
  ]
)
