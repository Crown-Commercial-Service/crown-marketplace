module LegalServices
  class Journey::Lot3Results
    include Steppable

    def next_step_class
      Journey::Lot3Results
    end
  end
end
