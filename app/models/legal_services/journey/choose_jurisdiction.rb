module LegalServices
  class Journey::ChooseJurisdiction
    include Steppable

    attribute :jurisdiction
    validates :jurisdiction, presence: true

    def next_step_class
      Journey::ChooseServices
    end
  end
end
