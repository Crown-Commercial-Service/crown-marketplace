module LegalServices
  class Journey::Lot2FullService
    include Steppable
    def next_step_class
      Journey::Lot2FullService
    end
  end
end
