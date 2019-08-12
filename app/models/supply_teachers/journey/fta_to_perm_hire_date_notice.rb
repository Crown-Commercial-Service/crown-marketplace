module SupplyTeachers
  class Journey::FTAToPermHireDateNotice
    include Steppable

    def next_step_class
      Journey::FTAToPermFixedTermFee
    end
  end
end
