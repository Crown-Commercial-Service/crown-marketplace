module SupplyTeachers
  class JobType
    include StaticRecord

    attr_accessor :code, :description, :role

    def self.[](code)
      find_by(code: code).description
    end

    def self.find_role_by(code:)
      find_by(code: code, role: 'true')
    end

    def self.roles
      where(role: 'true')
    end

    def self.all_codes
      all.map(&:code)
    end
  end

  JobType.load_csv('supply_teachers/job_types.csv')
end
