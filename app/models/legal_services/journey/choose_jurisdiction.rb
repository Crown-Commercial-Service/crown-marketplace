module LegalServices
  class Journey::ChooseJurisdiction
    include Steppable

    attribute :lot
    validates :lot, inclusion: ['2a', '2b', '2c']

    def next_step_class
      Journey::ChooseServices
    end
  end
end
