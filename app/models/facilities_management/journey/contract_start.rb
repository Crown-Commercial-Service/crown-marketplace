module FacilitiesManagement
  class Journey::ContractStart
    include Steppable

    attribute :day
    attribute :month
    attribute :year

    def next_step_class
      Journey::Summary
    end
  end
end
