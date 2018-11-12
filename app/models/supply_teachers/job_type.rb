module SupplyTeachers
  class JobType
    include StaticRecord

    attr_accessor :code, :description
  end

  JobType.load_csv('supply_teachers/job_types.csv')
end
