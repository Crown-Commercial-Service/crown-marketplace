module LegalServices
  class Journey::Sorry
    include Steppable
    def next_step_class
      Journey::Sorry
    end
  end
end
