module LegalServices
  class Journey::ChooseJurisdiction
    include Steppable

    attribute :jurisdiction
    validates :jurisdiction, inclusion: ['a', 'b', 'c']

    def next_step_class
      Journey::ChooseServices
    end
  end
end
