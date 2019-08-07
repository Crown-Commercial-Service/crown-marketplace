module LegalServices
  class Journey::SelectLot
    include Steppable
    attribute :lot
    validates :lot, inclusion: ['1', '2', '3', '4']

    def self.lots
      LegalServices::Lot.all.sort_by(&:number)
    end

    def next_step_class
      case lot
      when '1'
        Journey::ChooseServices
      when '2'
        Journey::ChooseJurisdiction
      else
        Journey::Suppliers
      end
    end
  end
end
