module ManagementConsultancy
  module Steps
    class ChooseServices
      include JourneyStep

      attribute :services, Array
      validates :services, length: { minimum: 1 }

      def services_for_lot(lot)
        ManagementConsultancy::Service.where(lot_number: lot).sort_by(&:code)
      end

      def next_step_class
        ChooseExpenses
      end
    end
  end
end
