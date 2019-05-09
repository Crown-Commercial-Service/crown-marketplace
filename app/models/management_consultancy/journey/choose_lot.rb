module ManagementConsultancy
  class Journey::ChooseLot
    include Steppable

    attribute :lot
    attribute :framework
    validates :lot, inclusion: {
      in: ['1', '2', '3', '4', 'MCF2.3']
    }

    def next_step_class
      Journey::ChooseServices
    end
  end
end
