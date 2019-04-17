module Apprenticeships
  class Journey::FindApprentices
    include Steppable

    attribute :training_course
    validates :training_course, inclusion: ['yes', 'no']

    def next_step_class
      case training_course
      when 'yes'
        Journey::FindApprentices2
      else
        Journey::Understanding
      end
    end
  end
end
