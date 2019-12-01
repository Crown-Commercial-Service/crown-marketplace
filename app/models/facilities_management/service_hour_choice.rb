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
    attribute :uom, Integer, default: nil

    # these are used to capture validation messages for the time input-groups
    attr_accessor :start_time
    attr_accessor :end_time

    validates :service_choice, inclusion: { in: SERVICE_CHOICES }
    validates :start_ampm, inclusion: { in: %w[AM PM] }, if: -> { service_choice&.to_sym == :hourly }
    validates :end_ampm, inclusion: { in: %w[AM PM] }, if: -> { service_choice&.to_sym == :hourly }

    # numerical validation occurs implicitly below, and captures any failures in high-level errors
    # against start_time and end_time
    validate :validate_choice

    # Used to serialise object to a hash
    def self.dump(service_hour_choice)
      return service_hour_choice if service_hour_choice.is_a? ServiceHourChoice

      service_hour_choice.select { |attribute| attribute unless attribute.empty? }.to_h.merge('uom': ServiceHourChoice.calculate_total_hours(service_hour_choice))
    end

    # Used to deserialise object form a hash
    def self.load(service_hour_choice)
      new if service_hour_choice.is_a? String

      result = new(service_hour_choice)
      result[:uom] = ServiceHourChoice.calculate_total_hours(service_hour_choice)

      result
    end

    def self.calculate_total_hours(service_hours_hash)
      return 0 if service_hours_hash.nil?

      options = { nil: 0, not_required: 0, all_day: 24, hourly: 0 }

      return options[service_hours_hash[:service_choice].to_sym] unless service_hours_hash[:service_choice].to_sym == :hourly

      return 0 if service_hours_hash[:start_hour].blank? || service_hours_hash[:start_minute].blank?

      return 0 if service_hours_hash[:end_hour].blank? || service_hours_hash[:end_minute].blank?

      time_range(service_hours_hash)
    end

    def self.time_range(service_hours_hash)
      start_hour_value_proc = -> { service_hours_hash[:start_ampm] == 'PM' ? service_hours_hash[:start_hour].to_i + 12 : service_hours_hash[:start_hour].to_i }
      start_hour_value = start_hour_value_proc.call
      start_minute_value = service_hours_hash[:start_hour]
      end_hour_value_proc = -> { service_hours_hash[:end_ampm] == 'PM' ? service_hours_hash[:end_hour].to_i + 12 : service_hours_hash[:end_hour].to_i }
      end_hour_value = end_hour_value_proc.call
      end_minute_value = service_hours_hash[:end_hour]

      start_time = (format('%02d', start_hour_value) + format('%02d', start_minute_value)).to_i
      end_time = (format('%02d', end_hour_value) + format('%02d', end_minute_value)).to_i

      (ServiceHourChoice.max(start_time.to_i, end_time.to_i) - ServiceHourChoice.min(start_time.to_i, end_time.to_i)) .fdiv(60).round(2)
    end

    def total_hours
      return 0 unless SERVICE_CHOICES.include?(service_choice)

      options = { nil: 0, not_required: 0, all_day: 24, hourly: time_range }
      options[service_choice.to_sym]
    end

    def to_summary
      return 'na' if service_choice.nil?

      return I18n.t('activemodel.attributes.facilities_management/service_hour_choice/service_choice.not_required') if service_choice&.to_sym == :not_required

      return I18n.t('activemodel.attributes.facilities_management/service_hour_choice/service_choice.all_day') if service_choice&.to_sym == :all_day

      time_message
    end

    def time_message
      "<span aria-role='#{I18n.t('activemodel.attributes.facilities_management/service_hour_choice/service_choice.hourly')}'>#{start_time_summary} #{I18n.t('activemodel.attributes.facilities_management/service_hour_choice/service_choice.time_to')} #{end_time_summary}</span>"
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

    class << self
      def max(lhs, rhs)
        lhs > rhs ? lhs : rhs
      end

      def min(lhs, rhs)
        lhs < rhs ? lhs : rhs
      end
    end

    private

    # Used to render summary information
    def time_range
      return 0 if start_hour.blank? || start_minute.blank?

      return 0 if end_hour.blank? || end_minute.blank?

      hours_between_times
    end

    def hours_between_times
      start_time = start_time_value
      end_time = end_time_value
      (ServiceHourChoice.max(start_time.to_i, end_time.to_i) - ServiceHourChoice.min(start_time.to_i, end_time.to_i)) .fdiv(60).round(2)
    end
    ########

    # Used to validate the week
    def validate_choice
      return if errors.present?

      return if %i[not_required all_day].include? service_choice.to_sym

      validate_numbers
      validate_number_ranges
      return if errors.present?

      validate_time_sequence
    end

    def validate_numbers
      %i[start_hour start_minute].each { |s| test_for_integer(s, :start_time) }
      %i[end_hour end_minute].each { |s| test_for_integer(s, :end_time) }
    end

    def test_for_integer(attribute, error_symbol)
      errors.add(error_symbol, :invalid) unless attributes[attribute].to_s == attributes[attribute].to_i.to_s
    end

    def integer?(attribute_symbol)
      attributes[attribute_symbol].to_s == attributes[attribute_symbol].to_i.to_s
    end

    def validate_number_ranges
      validate_minute_range(:start_time, 'start') if validate_hour_range(:start_time, 'start')

      validate_minute_range(:end_time, 'end') if validate_hour_range(:end_time, 'end')
    end

    def validate_hour_range(error_symbol, attribute_prefix)
      attribute_symbol = "#{attribute_prefix}_hour".to_sym
      return unless integer? attribute_symbol

      errors.add(error_symbol.to_sym, :not_a_date) unless attributes[attribute_symbol].between?(0, 12)
      attributes[attribute_symbol].between?(0, 12)
    end

    def validate_minute_range(error_symbol, attribute_prefix)
      attribute_symbol = "#{attribute_prefix}_minute".to_sym
      return unless integer? attribute_symbol

      errors.add(error_symbol.to_sym, :not_a_date) unless attributes[attribute_symbol].between?(0, 59)
    end

    # rubocop:disable Metrics/CyclomaticComplexity
    def validate_time_sequence
      errors.add(:end_time, :after) if end_ampm != start_ampm && end_ampm == 'pm' && end_time_value <= start_time_value

      errors.add(:start_time, :before) if end_ampm != start_ampm && end_ampm == 'am' && end_time_value >= start_time_value
    end
    # rubocop:enable Metrics/CyclomaticComplexity

    def start_time_value
      time_value(format('%02d', start_hour_inc_meridian), format('%02d', start_minute))
    end

    def end_time_value
      time_value(format('%02d', end_hour_inc_meridian), format('%02d', end_minute))
    end

    def start_hour_inc_meridian
      return start_hour if start_ampm == 'AM'

      start_hour + 12
    end

    def end_hour_inc_meridian
      return end_hour if end_ampm == 'AM'

      end_hour + 12
    end

    def time_value(first, second)
      first + second
    end
    #######
  end
end
