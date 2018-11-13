module ManagementConsultancy
  module Steps
    class Lot
      include JourneyStep
    end

    class ChooseLot
      include JourneyStep

      attribute :lot
      validates :lot, inclusion: {
        in: ['lot1', 'lot2', 'lot3', 'lot4']
      }

      def next_step_class
        Lot
      end
    end
  end
end
