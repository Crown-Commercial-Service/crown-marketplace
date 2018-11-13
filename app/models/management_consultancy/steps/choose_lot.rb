module ManagementConsultancy
  module Steps
    class Suppliers
      include JourneyStep
    end

    class ChooseLot
      include JourneyStep

      attribute :lot
      validates :lot, inclusion: {
        in: ['lot1', 'lot2', 'lot3', 'lot4']
      }

      def next_step_class
        Suppliers
      end
    end
  end
end
