module SupplyTeachers
  class Journey::FtaToPermHireDateNotice

    attribute :fixed_term_fee

    def next_step_class
      Journey::FTAToPermFee
    end

  end
end
