module FacilitiesManagement
  class ServiceHourChoice
    include ActiveModel::Model
    include Virtus.model
    include ActiveModel::Serialization
    include ActiveModel::Callbacks

    SERVICE_CHOICES = %w[not_required all_day hourly].freeze
    PARAMETERS = %i[service_choice start_hour start_minute start_ampm end_hour end_minute end_ampm next_day].freeze

    attribute :service_choice, String, default: nil

    attribute :start_hour, Integer, default: nil
    attribute :start_minute, Integer, default: nil
    attribute :start_ampm, String, default: nil
    attribute :end_hour, Integer, default: nil
    attribute :end_minute, Integer, default: nil
    attribute :end_ampm, String, default: nil
    attribute :next_day, Boolean, default: false
    attribute :uom, Float, default: nil

    # these are used to capture validation messages for the time input-groups
    attr_accessor :start_time
    attr_accessor :end_time

    validates :service_choice, inclusion: { in: SERVICE_CHOICES }
    validates :start_hour, presence: true, if: -> { service_choice&.to_sym == :hourly }
    validates :start_minute, presence: true, if: -> { service_choice&.to_sym == :hourly }
    validates :start_ampm, inclusion: { in: %w[AM PM] }, if: -> { service_choice&.to_sym == :hourly }
    validates :end_hour, presence: true, if: -> { service_choice&.to_sym == :hourly }
    validates :end_minute, presence: true, if: -> { service_choice&.to_sym == :hourly }
    validates :end_ampm, inclusion: { in: %w[AM PM] }, if: -> { service_choice&.to_sym == :hourly }

    # Additional errors for the hourly choices
    validate :validate_choice, if: -> { service_choice&.to_sym == :hourly }

    # Used to serialise object to a hash
    def self.dump(service_hour_choice)
      return {} if service_hour_choice.nil?

      result = {}
      result = service_hour_choice.to_h if service_hour_choice.is_a? ServiceHourChoice

      result = service_hour_choice.select { |attribute| attribute unless attribute.empty? }.to_h unless service_hour_choice.is_a? ServiceHourChoice

      result.merge('uom': ServiceHourChoice.calculate_total_hours(service_hour_choice))
    end

    # Used to deserialise object form a hash
    def self.load(service_hour_choice)
      new if service_hour_choice.is_a? String

      result = new(service_hour_choice)
      result[:uom] = ServiceHourChoice.calculate_total_hours(service_hour_choice)

      result
    end

    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/PerceivedComplexity
    def self.calculate_total_hours(service_hours_hash)
      return 0 if service_hours_hash.nil?

      return 0 if service_hours_hash[:service_choice].nil?

      options = { nil: 0, not_required: 0, all_day: 24, hourly: 0 }

      return options[service_hours_hash[:service_choice].to_sym] unless service_hours_hash[:service_choice].to_sym == :hourly

      return 0 if service_hours_hash[:start_hour].blank? || service_hours_hash[:start_minute].blank?

      return 0 if service_hours_hash[:end_hour].blank? || service_hours_hash[:end_minute].blank?

      time_range(service_hours_hash)
    end
    # rubocop:enable Metrics/CyclomaticComplexity
    # rubocop:enable Metrics/PerceivedComplexity

    def self.time_range(service_hours_hash)
      return 0 if service_hours_hash.nil?

      start_time = convert_start_time_to_24(service_hours_hash[:start_hour].to_i, service_hours_hash[:start_minute].to_i, service_hours_hash[:start_ampm])
      end_time = convert_end_time_to_24(service_hours_hash[:end_hour].to_i, service_hours_hash[:end_minute].to_i, service_hours_hash[:end_ampm], service_hours_hash[:next_day])

      (end_time - start_time).abs / 3600
    end

    def self.convert_start_time_to_24(hour, minute, am_or_pm)
      if am_or_pm == 'AM'
        hour = 0 if hour == 12
      else
        hour += 12 unless hour == 12
      end
      Time.parse("#{hour}:#{minute}").utc
    end

    def self.convert_end_time_to_24(hour, minute, am_or_pm, next_day)
      if am_or_pm == 'AM'
        hour = 0 if hour == 12
      else
        hour += 12 unless hour == 12
      end
      time = Time.parse("#{hour}:#{minute}").utc
      time += days_to_add(hour, minute, next_day).days
      time
    end

    def self.days_to_add(hour, minute, next_day)
      count = 0
      count += 1 if (hour.zero? && minute.zero?) || next_day
      count
    end

    def total_hours
      return 0 unless SERVICE_CHOICES.include?(service_choice)

      options = { nil: 0, not_required: 0, all_day: 24, hourly: time_range }
      options[service_choice.to_sym]
    end

    def end_time_summary
      et = 'na'
      if end_hour && end_minute
        et = end_hour.to_s

        et += ":#{end_minute}" unless end_minute.zero?

        et += end_ampm.downcase
      end

      et
    end

    def start_time_summary
      st = 'na'
      if start_hour && start_minute
        st = start_hour.to_s
        st += ":#{start_minute}" unless start_minute.zero?

        st += start_ampm.downcase
      end

      st
    end

    def start_time_integer
      start_time_value.to_i
    end

    def end_time_integer
      end_time_value.to_i
    end

    private

    # Used to render summary information
    def time_range
      return 0 if start_hour.blank? || start_minute.blank?

      return 0 if end_hour.blank? || end_minute.blank?

      hours_between_times
    end

    def hours_between_times
      ServiceHourChoice.time_range(to_h)
    end
    ########

    # Used to validate the week
    def validate_choice
      if errors.present?
        add_errors_to_time
        return
      end

      return if %i[not_required all_day].include? service_choice.to_sym

      validate_total_hours
      return if errors.present?

      validate_time_sequence
    end

    def validate_total_hours
      errors.add(:end_time, :too_long) if total_hours > 24
    end

    def validate_time_sequence
      errors.add(:end_time, :after, date: start_time) if end_time_value <= start_time_value
    end

    def start_time_value
      time_value(format('%02d', start_hour_inc_meridian), format('%02d', start_minute))
    end

    def end_time_value
      time_value(format('%02d', end_hour_inc_meridian), format('%02d', end_minute))
    end

    def start_hour_inc_meridian
      hour = start_hour

      if start_ampm == 'AM'
        hour = 0 if hour == 12
      else
        hour += 12 unless hour == 12
      end
      hour
    end

    def end_hour_inc_meridian
      hour = end_hour
      minute = end_minute
      if end_ampm == 'AM'
        hour = 0 if hour == 12
      else
        hour += 12 unless hour == 12
      end
      hour += 24 * self.class.days_to_add(hour, minute, next_day)
      hour
    end

    def time_value(first, second)
      first + second
    end

    def add_errors_to_time
      errors.add(:start_time, :invalid) unless (errors.keys & %i[start_hour start_minute start_ampm]).empty?
      errors.add(:end_time, :invalid) unless (errors.keys & %i[end_hour end_minute end_ampm]).empty?
    end
    #######
  end
end
