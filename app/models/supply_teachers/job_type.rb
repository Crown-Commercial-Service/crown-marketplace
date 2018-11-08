module SupplyTeachers
  class JobType
    include StaticRecord

    attr_accessor :code, :description
  end

  JobType.load_csv('job_types.csv')
end
