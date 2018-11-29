module ManagementConsultancy
  class Journey::ChooseExpenses
    include JourneyStep

    attribute :expenses
    validates :expenses, inclusion: ['paid', 'not_paid']

    def next_step_class
      Journey::ChooseRegions
    end
  end
end
