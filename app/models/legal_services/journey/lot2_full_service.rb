module LegalServices
  class Journey::Lot2FullService
    include Steppable
    def next_step_class
<<<<<<< Updated upstream
      Journey::Lot2FullService
=======
      Journey::LegalJurisdiction
>>>>>>> Stashed changes
    end
  end
end
