module Steps
  class Suppliers
    include JourneyStep
  end

  class ValueBand
    include JourneyStep

    attribute :value_band
    validates :value_band, inclusion: {
      in: ['under1_5m', 'under7m', 'under50m', 'over50m']
    }

    def next_step_class
      case value_band
      when 'under1_5m'
        SupplierRegion
      when 'under7m'
        SupplierRegion
      when 'under50m'
        Suppliers
      when 'over50m'
        Suppliers
      end
    end
  end
end
