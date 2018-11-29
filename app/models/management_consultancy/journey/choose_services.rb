module ManagementConsultancy
  class Journey::ChooseServices
    include ::Journey::Step

    attribute :services, Array
    validates :services, length: { minimum: 1 }

    def services_for_lot(lot)
      ManagementConsultancy::Service.where(lot_number: lot).sort_by(&:code)
    end

    def next_step_class
      Journey::ChooseExpenses
    end
  end
end
