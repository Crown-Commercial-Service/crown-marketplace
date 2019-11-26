module FacilitiesManagement
  class ServiceHourChoice
    include ActiveModel::Model
    include Virtus.model
    include ActiveModel::Serialization
    include ActiveModel::Callbacks

    SERVICE_CHOICES = %w[not_required all_day hourly].freeze
    PARAMETERS = %i[service_choice start_hour start_minute start_ampm end_hour end_minute end_ampm].freeze

    attribute :service_choice, String, default: nil

    attribute :start_hour, Integer, default: nil
    attribute :start_minute, Integer, default: nil
    attribute :start_ampm, String, default: nil
    attribute :end_hour, Integer, default: nil
    attribute :end_minute, Integer, default: nil
    attribute :end_ampm, String, default: nil

    validates :service_choice, presence: true
    validates :service_choice, inclusion: { in: SERVICE_CHOICES }
    # validates :start_ampm, inclusion: { in: %w[am pm] }, if: -> { service_choice&.to_sym == :hourly }
    # validates :start_hour, numericality: { only_integer: true }, if: -> { service_choice == :hourly }
    # validates :start_hour, inclusion: { in: 1..12 }, if: -> { service_choice == :hourly }
    # validates :start_minute, numericality: { only_integer: true }, if: -> { service_choice == :hourly }
    # validates :start_minute, inclusion: { in: 0..59 }, if: -> { service_choice == :hourly }
    # validates :end_ampm, inclusion: { in: %w[am pm] }, if: -> { service_choice == :hourly }
    # validates :end_hour, numericality: { only_integer: true }, if: -> { service_choice == :hourly }
    # validates :end_hour, inclusion: { in: 1..12 }, if: -> { service_choice == :hourly }
    # validates :end_minute, numericality: { only_integer: true }, if: -> { service_choice == :hourly }
    # validates :end_minute, inclusion: { in: 0..59 }, if: -> { service_choice == :hourly }
    #
    # validate :validate_choice

    define_model_callbacks :initialize, only: [:after]
    after_initialize :valid?

    def initialize(params = {})
      super(params)
    end

    def self.dump(service_hour_choice)
      # new_hash = {}
      # new_hash.merge!(service_hour_choice.attributes.select { |_key, value| value.present? })
      # new_hash

      return service_hour_choice if service_hour_choice.is_a? ServiceHourChoice

      service_hour_choice.select { |attribute| attribute unless attribute.empty? }.to_h
    end

    def self.load(service_hour_choice)
      new if service_hour_choice.is_a? String

      new(service_hour_choice)
    end

    def total_hours
      return 0 if service_choice.nil?

      return 0 if service_choice.to_sym == :not_required

      return 24 if service_choice.to_sym == :all_day

      return time_range if service_choice.to_sym == :hourly

      0
    end

    def time_range
      start_time = time_value(format('%02d', start_hour), format('%02d', start_minute))
      end_time = time_value(format('%02d', end_hour), format('%02d', end_minute))
      (max(start_time.to_i, end_time.to_i) - min(start_time.to_i, end_time.to_i)) / 60
    end

    def max(lhs, rhs)
      lhs > rhs ? lhs : rhs
    end

    def min(lhs, rhs)
      lhs < rhs ? lhs : rhs
    end

    def to_summary
      return 'na' unless valid?

      return I18n.t('activemodel.service_hour_choice.not_required') if service_choice.to_sym == :not_required

      return I18n.t('activemodel.service_hour_choice.all_day') if service_choice.to_sym == :all_day

      time_message
    end

    def time_message
      "#{start_time_summary} #{I18n.t('activemodel.service_hour_choice.time_to')} #{end_time_summary}"
    end

    def end_time_summary
      et = 'na'
      if end_hour && end_minute
        et = end_hour.to_s

        et += ":#{end_minute}" unless end_minute.zero?

        et += end_ampm
      end

      et
    end

    def start_time_summary
      st = 'na'
      if start_hour && start_minute
        st = start_hour.to_s
        st += ":#{start_minute}" unless start_minute.zero?

        st += start_ampm
      end

      st
    end

    def any_present?
      errors.add(:base, :invalid) if attributes.keys.all? { |k| attributes[k].blank? }
      errors.blank?
    end

    private

    def validate_choice
      return if errors.present?

      return if %i[not_required all_day].include? service_choice.to_sym

      validate_numbers
      return if errors.present?

      validate_time_range
    end

    def validate_numbers
      %i[start_hour start_minute end_hour end_minute].each { |s| test_for_integer(s) }
    end

    def test_for_integer(symbol)
      errors.add(symbol, :invalid) unless attributes[symbol].to_s == attributes[symbol].to_i.to_s
    end

    # rubocop:disable Metrics/CyclomaticComplexity
    def validate_time_range
      errors.add(:end_hour, :after) if [:end_ampm] != [:start_ampm] && [:end_ampm] == 'pm' && end_time_value <= start_time_value

      errors.add(:start_hour, :before) if [:end_ampm] != [:start_ampm] && [:end_ampm] == 'am' && end_time_value >= start_time_value
    end
    # rubocop:enable Metrics/CyclomaticComplexity

    def start_time_value
      time_value(format('%02d', start_hour), format('%02d', start_minute))
    end

    def end_time_value
      time_value(format('%02d', end_hour), format('%02d', end_minute))
    end

    def time_value(first, second)
      first + second
    end
  end
end
