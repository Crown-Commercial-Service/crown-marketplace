module FacilitiesManagement
  class Journey::ValueBand
    include ::Journey::Step

    attribute :value_band
    validates :value_band, inclusion: {
      in: ['under1_5m', 'under7m', 'under50m', 'over50m']
    }

    def next_step_class
      case value_band
      when 'under1_5m'
        Journey::SupplierRegion
      when 'under7m'
        Journey::SupplierRegion
      when 'under50m'
        Journey::Suppliers
      when 'over50m'
        Journey::Suppliers
      end
    end
  end
end
