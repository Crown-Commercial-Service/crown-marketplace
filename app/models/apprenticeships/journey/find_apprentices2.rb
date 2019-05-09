module Apprenticeships
  class Journey::FindApprentices2
    include Steppable
    attribute :das
    validates :das, inclusion: ['yes', 'no']
    def next_step_class
      case das
      when 'yes'
        Journey::FindApprentices3
      else
        Journey::Signup
      end
    end
  end
end
