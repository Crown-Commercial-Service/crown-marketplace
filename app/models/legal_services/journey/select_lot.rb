module LegalServices
  class Journey::SelectLot
    include Steppable
    attribute :selected_lot
    validates :selected_lot, inclusion: ['lot1', 'lot2', 'lot3', 'lot4']

    def next_step_class
      case selected_lot
      when 'lot1'
        Journey::Lot1RegionalService
      when 'lot2'
        Journey::Lot2FullService
      when 'lot3', 'lot4'
        Journey::SupplierResults
      end
    end
  end
end
