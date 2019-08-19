module LegalServices
  class Journey::ChooseServices
    include Steppable

    attribute :lot
    attribute :services, Array
    validates :services, length: { minimum: 1 }

    def services_for_lot(lot, jurisdiction, central_government = 'no')
      if lot == '2'
        LegalServices::Service.where(lot_number: lot + jurisdiction).sort_by(&:name)
      else
        LegalServices::Service.where(lot_number: lot, central_government: central_government).sort_by(&:name)
      end
    end

    def selected_lot
      LegalServices::Lot.find_by(number: lot)
    end

    def next_step_class
      case lot
      when '1'
        Journey::ChooseRegions
      else
        Journey::Suppliers
      end
    end
  end
end
