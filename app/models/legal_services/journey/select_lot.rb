module LegalServices
  class Journey::SelectLot
    include Steppable
    attribute :select_lot
    validates :select_lot, inclusion: ['lot1', 'lot2', 'lot3', 'lot4']

    def next_step_class
      case select_lot
      when 'lot1'
        Journey::Lot1RegionalService
      when 'lot2'
        Journey::Lot2FullService
      when 'lot3'
        Journey::Lot3Results
      when 'lot4'
        Journey::Lot4Results
      end
    end
  end
end
