module Apprenticeships
  class Journey::FindApprentices2
    byebug
    include Steppable
   
    attribute :das
    validates :das, inclusion: ['yes', 'no']

    def next_step_class
      byebug
      case das
      when 'yes'
        Journey::FindApprentices3
      else
        Journey::Signup
      end
    end

  end
end
