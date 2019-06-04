module LegalServices
  class Journey::Lot4Results
    include Steppable

    def next_step_class
      Journey::Lot4Results
    end
  end
end
