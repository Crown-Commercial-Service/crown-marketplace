module ManagementConsultancy
  class Journey::ChooseHelpNeeded
    include Steppable

    def next_step_class
      Journey::ChooseLot
    end
  end
end
