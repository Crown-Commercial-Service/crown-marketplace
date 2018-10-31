class JobType
  include StaticRecord

  attr_accessor :code, :description
end

require 'csv'
JobType.define(*CSV.read(Rails.root.join('data', 'job_types.csv')))
