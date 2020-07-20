module Apprenticeships
  class Journey::FindApprentices3
    include Steppable
    def next_step_class
      Journey::FindApprentices4
    end
  end
end
