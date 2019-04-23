module Apprenticeships
  class Journey::FindApprentices5
    include Steppable
    attribute :rating, Array
    validates :rating, length: { minimum: 1 }
    def next_step_class
      Journey::FindApprentices4
    end
  end
end
