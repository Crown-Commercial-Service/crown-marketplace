module FacilitiesManagement
  class Journey::Summary
    include Steppable

    attribute :day
    attribute :month
    attribute :year

    def next_step_class
      Journey::Summary
    end
  end
end
