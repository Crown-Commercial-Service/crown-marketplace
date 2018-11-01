module Steps
  class Suppliers < JourneyStep; end

  class ValueBand < JourneyStep
    attribute :value_band
    validates :value_band, inclusion: {
      in: ['under1_5m', 'under7m', 'under50m', 'over50m'],
      message: I18n.t('journey.value_band.validation_error')
    }

    def next_step_class
      case value_band
      when 'under1_5m'
        Suppliers
      when 'under7m'
        Suppliers
      when 'under50m'
        Suppliers
      when 'over50m'
        Suppliers
      end
    end
  end
end
