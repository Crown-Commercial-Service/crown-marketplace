module ManagementConsultancy
  module Steps
    class Suppliers
      include JourneyStep
    end

    class ChooseLot
      include JourneyStep

      attribute :lot
      validates :lot, inclusion: {
        in: ['1', '2', '3', '4']
      }

      def next_step_class
        Suppliers
      end
    end
  end
end
