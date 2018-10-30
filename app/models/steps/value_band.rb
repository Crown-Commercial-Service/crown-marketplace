module Steps
  class Lot1aSuppliers < JourneyStep; end
  class Lot1bSuppliers < JourneyStep; end
  class Lot1cSuppliers < JourneyStep; end

  class ValueBand < JourneyStep
    attribute :value_band
    validates :value_band, inclusion: {
      in: ['under1_5m', 'under7m', 'under50m', 'over50m'],
      message: I18n.t('journey.value_band.validation_error')
    }

    def next_step_class
      case value_band
      when 'under1_5m'
        Lot1aSuppliers
      when 'under7m'
        Lot1aSuppliers
      when 'under50m'
        Lot1bSuppliers
      when 'over50m'
        Lot1cSuppliers
      end
    end
  end
end
