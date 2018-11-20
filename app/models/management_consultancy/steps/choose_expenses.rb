module ManagementConsultancy
  module Steps
    class ChooseExpenses
      include JourneyStep

      attribute :expenses
      validates :expenses, inclusion: ['paid', 'not_paid']

      def next_step_class
        ChooseRegions
      end
    end
  end
end
