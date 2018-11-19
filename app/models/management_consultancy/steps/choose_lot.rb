module ManagementConsultancy
  module Steps
    class ChooseLot
      include JourneyStep

      attribute :lot
      validates :lot, inclusion: {
        in: ['1', '2', '3', '4']
      }

      def next_step_class
        ChooseServices
      end
    end
  end
end
