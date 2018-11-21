module TempToPermCalculator
  class Journey < ::Journey
    def initialize(slug, params)
      paths = JourneyPaths.new(self.class.journey_name)
      super(self.class.first_step_class, slug, params, paths)
    end

    def self.journey_name
      'temp-to-perm-calculator'
    end

    def self.first_step_class
      Steps::ContractStart
    end

    def template
      [self.class.journey_name.underscore, current_step.template].join('/')
    end
  end
end
